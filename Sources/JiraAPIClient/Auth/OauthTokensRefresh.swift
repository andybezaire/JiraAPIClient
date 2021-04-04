//
//  OauthTokensRefresh.swift
//
//
//  Created by Andy on 4.4.2021.
//

import Authorization
import Combine
import Foundation
import JiraAPI

extension JiraAPIClient {
    func oauthTokensRefresh(for refresh: JiraAPI.Auth.RefreshToken) -> AnyPublisher<Auth.Tokens, Swift.Error> {
        guard let request = try? JiraAPI.Auth.Request.oauthTokenRefresh(
            clientID: config.clientID,
            clientSecret: config.clientSecret,
            refreshToken: refresh
        ) else {
            return Fail(error: Error.invalidOauthTokenRequest)
                .eraseToAnyPublisher()
        }

        logger?.debug("Tokens refresh request: \(request.oneLiner)")

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { _ in Error.oauthTokenRequestFailure }
            .map(\.data)
            .logOutput(to: logger) { logger, data in
                let body = String(data: data, encoding: .utf8) ?? "nil"
                logger.debug("Tokens refresh response payload: \(body, privacy: .private)")
            }
            .flatMap { Just($0)
                .decode(type: JiraAPI.Models.OauthTokenResponse.self, decoder: JSONDecoder())
                .mapError { _ in Error.oauthTokenDecodeFailure }
            }
            .map { Auth.Tokens(token: $0.token, refresh: $0.refresh) }
            .log(to: logger, prefix: "Tokens refresh") { logger, output in
                logger.log("Tokens refresh got tokens: \(output, privacy: .private)")
            }
            .eraseToAnyPublisher()
    }
}
