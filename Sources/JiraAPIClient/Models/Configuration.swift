//
//  Configuration.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import AuthenticationServices
import Foundation
import JiraAPI

public extension JiraAPIClient {
    typealias ClientID = JiraAPI.Auth.ClientID
    typealias ClientSecret = JiraAPI.Auth.ClientSecret
    typealias Scope = JiraAPI.Auth.Scope
    typealias CallbackURLScheme = String
    typealias CallbackURLHost = String
    typealias UserBoundValue = JiraAPI.Auth.UserBoundValue
    typealias RedirectURI = JiraAPI.Auth.RedirectURI

    struct Configuration {
        let isAuthorizationEphemeral: Bool
        let clientID: ClientID
        let clientSecret: ClientSecret
        let scopes: [Scope]
        let callbackURLScheme: CallbackURLScheme
        let callbackURLHost: CallbackURLHost
        let userBoundValue: UserBoundValue
        let authenticationSessionContextProvider: ASWebAuthenticationPresentationContextProviding?

        var redirectURI: RedirectURI {
            var uri = URLComponents()
            uri.scheme = callbackURLScheme
            uri.host = callbackURLHost
            guard let url = uri.url else {
                fatalError("Malformed callback URL. Please check your callbackURLScheme and callbackURLHost")
            }
            return "\(url)"
        }

        /// Create a configuration object
        /// - Parameters:
        ///   - isAuthorizationEphemeral: false if you want the authentication session
        ///   to have access to the safari saved account and passwords for that user, default is false
        ///   - clientID: (required) Set this to the Client ID for your app. Find this in Settings
        ///   for your app in the [developer console](https://developer.atlassian.com/console/myapps/).
        ///   - clientSecret: (required) Set this to the Secret for your app. Find this in Settings
        ///   for your app in the [developer console](https://developer.atlassian.com/console/myapps/).
        ///   - scopes: (required) Set this to the desired scopes: Separate multiple scopes
        ///   with a space. Only choose from the scopes that you have already added to the APIs
        ///   for your app in the [developer console](https://developer.atlassian.com/console/myapps/).
        ///   You may specify scopes from multiple products.
        ///   - callbackURLScheme: (required) Set this to the callback URL configured in Authorization
        ///   for your app in the [developer console](https://developer.atlassian.com/console/myapps/).
        ///   - callbackURLHost: (required) Set this to the callback URL configured in Authorization
        ///   for your app in the [developer console](https://developer.atlassian.com/console/myapps/).
        ///   - userBoundValue: If nil, the system will use the value stored in UserDefaults. If no value yet
        ///    in user defaults, then the system will create one using `UUID().uuidString`. Set this to a
        ///    value that is associated with the user you are directing to the authorization URL, for example, a hash
        ///    of the user's session ID. Make sure that this is a value that cannot be guessed. You may be able to
        ///    generate and validate this value automatically, if you are using an OAuth 2.0 client library or an
        ///    authentication library with OAuth 2.0 support. For more information, including why this parameter
        ///    is required for security, see [What is the state parameter used for?](
        ///    https://developer.atlassian.com/cloud/jira/platform/oauth-2-3lo-apps/#faq3).
        ///   - authenticationSessionContextProvider: The context used to present the authentication session sheet.
        ///    Defaults to current context.
        ///   - isUsingRefresh: If true, then also ask for the refresh token along with the access token. default `true`
        public init(
            isAuthorizationEphemeral: Bool = false,
            clientID: ClientID,
            clientSecret: ClientSecret,
            scopes: [Scope],
            callbackURLScheme: CallbackURLScheme,
            callbackURLHost: CallbackURLHost,
            userBoundValue: UserBoundValue,
            authenticationSessionContextProvider: ASWebAuthenticationPresentationContextProviding? = ContextProvider(),
            isUsingRefresh: Bool = true
        ) {
            self.isAuthorizationEphemeral = isAuthorizationEphemeral
            self.clientID = clientID
            self.clientSecret = clientSecret
            self.scopes = scopes + (isUsingRefresh ? ["offline_access"] : [])
            self.callbackURLScheme = callbackURLScheme
            self.callbackURLHost = callbackURLHost
            self.userBoundValue = userBoundValue
            self.authenticationSessionContextProvider = authenticationSessionContextProvider
        }

        /// Default context provider makes a new modal presentation (at least in ios)
        public class ContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
            public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
                return ASPresentationAnchor()
            }
        }
    }
}
