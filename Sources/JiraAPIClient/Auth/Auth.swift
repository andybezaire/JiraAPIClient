//
//  File.swift
//
//
//  Created by Auth on 5.4.2021.
//

import Authorization
import Combine
import Foundation

extension JiraAPIClient {
    func doGetTokens() -> AnyPublisher<Auth.Tokens, Swift.Error> {
        authorizationCode()
            .flatMap(oauthTokens)
            .eraseToAnyPublisher()
    }

    func doRefreshToken(refresh: Auth.Refresh) -> AnyPublisher<Auth.Tokens, Swift.Error> {
        oauthTokensRefresh(for: refresh)
            .eraseToAnyPublisher()
    }
}
