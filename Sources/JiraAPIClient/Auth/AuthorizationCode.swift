//
//  AuthorizationCode.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import AuthenticationServices
import Combine
import CombineExtras
import Foundation
import JiraAPI

typealias Code = String

extension JiraAPIClient {
    func authorizationCode() -> AnyPublisher<Code, Swift.Error> {
        return Future<URL, Swift.Error> { [self] completion in
            guard let authURL = try? JiraAPI.Auth.URL.authorize(
                clientID: config.clientID,
                scopes: config.scopes,
                redirectURI: config.redirectURI,
                userBoundValue: config.userBoundValue
            ) else { completion(.failure(Error.invalidAuthURL)); return }
            let authSession =
                AuthSession(
                    url: authURL,
                    callbackURLScheme: config.callbackURLScheme,
                    presentationContextProvider: config.authenticationSessionContextProvider,
                    prefersEphemeralWebBrowserSession: config.isAuthorizationEphemeral
                ) { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    } else {
                        completion(.failure(Error.authorizationCodeInternalError))
                    }
                }

            authSession.start()
        }
        .map { $0.queryItem(named: "code") }
        .tryMap {
            guard let code = $0 else { throw Error.authorizationCodeNotFound }
            return code
        }
        .log(to: logger, prefix: "Authorization code fetch") { logger, output in
            logger.log("Authorization code fetch got code: \(output, privacy: .private)")
        }
        .eraseToAnyPublisher()
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
