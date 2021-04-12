//
//  File.swift
//
//
//  Created by Andy on 11.4.2021.
//

import Combine
import Foundation
import JiraAPI

public extension JiraAPIClient {
    func signIn() -> AnyPublisher<Never, Swift.Error> {
        let signIn = PassthroughSubject<Void, Swift.Error>()

        signingInOut = auth.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    signIn.send(completion: .failure(error))
                case .finished:
                    signIn.send()
                }
            })

        return signIn
            .first()
            .flatMap(getResources)
            .logOutput(to: logger) { logger, _ in logger.log("SignIn updating resources") }
            .handleEvents(receiveOutput: _resources.send)
            .map { $0.first?.id }
            .logOutput(to: logger) { logger, _ in logger.log("SignIn setting cloudID") }
            .handleEvents(receiveOutput: cloudID.send)
            .map { _ in }
            .flatMap(getPublicProfile)
            .logOutput(to: logger) { logger, _ in logger.log("SignIn updating profile") }
            .handleEvents(receiveOutput: _userProfile.send)
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
