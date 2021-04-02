//
//  MockASWebAuthenticationSession.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import AuthenticationServices
import Foundation
import JiraAPIClient

public class MockAuthenticationSession: AuthenticationSession {
    var url: URL? { nil }
    var error: Error? { nil }

    let completionHandler: ASWebAuthenticationSession.CompletionHandler

    public required init(
        url: URL,
        callbackURLScheme: String?,
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding?,
        prefersEphemeralWebBrowserSession: Bool,
        completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler
    ) {
        self.completionHandler = completionHandler
        super.init(
            url: url,
            callbackURLScheme: callbackURLScheme,
            presentationContextProvider: presentationContextProvider,
            prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
            completionHandler: completionHandler
        )
    }

    public var startCallCount = 0

    override public func start() -> Bool {
        startCallCount += 1
        completionHandler(url, error)
        return true
    }
}

public class MockSuccessAuthenticationSession: MockAuthenticationSession {
    override var url: URL? {
        URLComponents(
            string: "www.example.com/success",
            queryItems: [URLQueryItem(name: "code", value: "CODE")]
        )?.url
    }
}

public class MockFailAuthenticationSession: MockAuthenticationSession {
    override var error: Error? { TestError.authenticationFail }
}

public enum TestError: Error {
    case authenticationFail
}

extension URLComponents {
    init?(string: String, queryItems: [URLQueryItem]?) {
        self.init(string: string)
        self.queryItems = queryItems
    }
}
