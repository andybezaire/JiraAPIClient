//
//  File.swift
//
//
//  Created by Andy on 11.4.2021.
//

import Combine

public extension JiraAPIClient {
    func signIn() -> AnyPublisher<Never, Swift.Error> {
        let signIn = PassthroughSubject<Never, Swift.Error>()

        signingInOut = auth.signIn()
            // get the resource
            // get the user
            .sink(receiveCompletion: signIn.send(completion:))

        return signIn
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
