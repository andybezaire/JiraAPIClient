//
//  File.swift
//
//
//  Created by Andy on 11.4.2021.
//

import Combine
import Foundation
import JiraAPI
import os.log

public extension JiraAPIClient {
    func signIn() -> AnyPublisher<Never, Swift.Error> {
        let getingResources = PassthroughSubject<Void, Swift.Error>()
        let getProfile = PassthroughSubject<Void, Swift.Error>()

        signingInOut = auth.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    getingResources.send(completion: .failure(error))
                case .finished:
                    getingResources.send()
                    getProfile.send()
                }
            })
        
        let gettingProfile = getProfile
            .flatMap(getPublicProfile)
            .logOutput(to: logger) { logger, profile in logger.log("SignIn updating profile for \(profile.name)") }
            .handleEvents(receiveOutput: _userProfile.send)

        return getingResources
            .first()
            .flatMap(getResources)
            .logOutput(to: logger) { logger, resources in logger.log("SignIn updating resources, count \(resources.count)") }
            .handleEvents(receiveOutput: _resources.send)
            .map { $0.first?.id }
            .logOutput(to: logger) { logger, cloudID in logger.log("SignIn setting cloudID to \(cloudID ?? "nil")") }
            .handleEvents(receiveOutput: cloudID.send)
            .zip(gettingProfile)
            .flatMap { _ in Empty<Never, Swift.Error>() }
            .eraseToAnyPublisher()
    }

    func signOut() -> AnyPublisher<Never, Swift.Error> {
        let signOut = PassthroughSubject<Never, Swift.Error>()

        signingInOut = auth.signOut()
            .sink(receiveCompletion: signOut.send(completion:))

        return signOut
            .eraseToAnyPublisher()
    }
}

extension JiraAPIClient {
    func getResources() -> AnyPublisher<[Resource], Swift.Error> {
        Just(())
            .tryMap { _ in try JiraAPI.Request.cloudResources() }
            .flatMap(auth.fetch)
            .map(\.data)
            .decode(type: [JiraAPI.Models.CloudResourceResponse].self, decoder: JSONDecoder())
            .map { resources in
                resources.map(Resource.init(response:))
            }
            .eraseToAnyPublisher()
    }
    
    func getPublicProfile() -> AnyPublisher<UserProfile, Swift.Error> {
        Just(())
            .tryMap { _ in try JiraAPI.Request.me() }
            .flatMap(auth.fetch)
            .map(\.data)
            .decode(type: JiraAPI.Models.MeResponse.self, decoder: JSONDecoder())
            .map(UserProfile.init(response:))
            .eraseToAnyPublisher()
    }
}

public extension JiraAPIClient {
    func setCloudID(_ cloudID: JiraAPI.Auth.CloudID?) {
        self.cloudID.send(cloudID)
    }
}
