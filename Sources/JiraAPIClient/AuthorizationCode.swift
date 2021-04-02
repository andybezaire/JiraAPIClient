//
//  AuthorizationCode.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import AuthenticationServices
import Combine
import Foundation
import JiraAPI

typealias Code = String

extension JiraAPIClient {
    func authorizationCode (
        contextProvider: ASWebAuthenticationPresentationContextProviding = contextProvider
    ) -> AnyPublisher<Code, Swift.Error> {
        return Future<URL, Swift.Error> { [self] completion in
            guard let authURL = try? JiraAPI.Auth.URL.authorize(
                clientID: config.clientID,
                scopes: config.scopes,
                redirectURI: config.redirectURI,
                userBoundValue: config.userBoundValue
            ) else { completion(.failure(Error.invalidAuthURL)); return }
            let authSession =
                ASWebAuthenticationSession(url: authURL, callbackURLScheme: config.callbackURLScheme) { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }

            authSession.presentationContextProvider = contextProvider
            authSession.prefersEphemeralWebBrowserSession = config.isAuthorizationEphemeral
            authSession.start()
        }
        .map { $0.queryItem(named: "code") }
        .tryMap {
            guard let code = $0 else { throw Error.authorizationCodeNotFound }
            return code
        }
        .eraseToAnyPublisher()
    }

    private static let contextProvider = ContextProvider()
    /// Default context provider makes a new modal presentation (at least in ios)
    private class ContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
        func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return ASPresentationAnchor()
        }
    }
}

extension URL {
    func queryItem(named name: String) -> String? {
        URLComponents(string: self.absoluteString)?
            .queryItems?
            .filter { $0.name == name }
            .first?
            .value
    }
}
