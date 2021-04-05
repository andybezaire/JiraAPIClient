//
//  OauthTokens.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import Authorization
import Combine
import Foundation
import JiraAPI

extension JiraAPIClient {
    func oauthTokens(for code: Code) -> AnyPublisher<Auth.Tokens, Swift.Error> {
        guard let request = try? JiraAPI.Auth.Request.oauthToken(
            clientID: config.clientID,
            clientSecret: config.clientSecret,
            code: code,
            redirectURI: config.redirectURI
        ) else {
            return Fail(error: Error.invalidOauthTokenRequest)
                .eraseToAnyPublisher()
        }

        return URLSession.shared.loggingDataTask(for: request, using: logger, prefix: "Tokens fetch")
            .mapError { _ in Error.oauthTokenRequestFailure }
            .map(\.data)
            .flatMap { Just($0)
                .decode(type: JiraAPI.Models.OauthTokenResponse.self, decoder: JSONDecoder())
                .mapError { _ in Error.oauthTokenDecodeFailure }
            }
            .map { Auth.Tokens(token: $0.token, refresh: $0.refresh) }
            .eraseToAnyPublisher()
    }
}
