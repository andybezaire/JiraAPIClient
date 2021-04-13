//
//  AuthenticationSession.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import AuthenticationServices
import Foundation

/// A session that an app uses to authenticate a user through a web service. Mockable.
///
/// Make sure to call `configure(..)`to return a configured object before calling `start()`
///
/// Use an ASWebAuthenticationSession instance to authenticate a user through a web service, including one run by a third party. Initialize the session with a URL that points to the authentication webpage. A browser loads and displays the page, from which the user can authenticate. In iOS, the browser is a secure, embedded web view. In macOS, the system opens the user’s default browser if it supports web authentication sessions, or Safari otherwise.
///
/// On completion, the service sends a callback URL to the session with an authentication token, and the session passes this URL back to the app through a completion handler.
///
/// For more details, see [Authenticating a User Through a Web Service](apple-reference-documentation://ls%2Fdocumentation%2Fauthenticationservices%2Fauthenticating_a_user_through_a_web_service).
open class AuthenticationSession {
    var session: ASWebAuthenticationSession?
    /// Creates and configures a web authentication session instance.
    /// - Parameters:
    ///   - url: A URL with the http or https scheme pointing to the authentication webpage.
    ///   - callbackURLScheme: The custom URL scheme that the app expects in the callback URL.
    ///   - presentationContextProvider: A delegate that provides a display context in which the system can present an authentication session to the user.
    ///   - prefersEphemeralWebBrowserSession: A Boolean value that indicates whether the session should ask the browser for a private authentication session.
    ///   - completionHandler: A completion handler the session calls when it completes successfully, or when the user cancels the session.
    ///
    /// Set prefersEphemeralWebBrowserSession to true to request that the browser doesn’t share cookies or other browsing data between the authentication session and the user’s normal browser session. Whether the request is honored depends on the user’s default web browser. Safari always honors the request.
    ///
    /// The value of this property is false by default.
    open func configure(
        url: URL,
        callbackURLScheme: String?,
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding?,
        prefersEphemeralWebBrowserSession: Bool,
        completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler
    ) -> Self {
        session = .init(url: url, callbackURLScheme: callbackURLScheme, completionHandler: completionHandler)
        session?.presentationContextProvider = presentationContextProvider
        session?.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
        return self
    }
    
    public init() {}

    /// Starts a web authentication session
    /// - Returns: A Boolean value indicating whether the web authentication session started successfully
    ///
    /// Make sure to call `configure(...)`to return a configured object before calling `start()`
    ///
    /// Only call this method once for a given ASWebAuthenticationSession instance after initialization. Calling the start() method on a canceled session results in a failure.
    ///
    /// In macOS, and for iOS apps with a deployment target of iOS 13 or later, after you call start(), the session instance stores a strong reference to itself. To avoid deallocation during the authentication process, the session keeps the reference until after it calls the completion handler.
    ///
    /// For iOS apps with a deployment target earlier than iOS 13, your app must keep a strong reference to the session to prevent the system from deallocating the session while waiting for authentication to complete.
    @discardableResult open func start() -> Bool {
        session?.start() ?? false
    }
}
