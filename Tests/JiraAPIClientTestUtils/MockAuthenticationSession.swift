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

    var completionHandler: ASWebAuthenticationSession.CompletionHandler!

    public override func configure(
        url: URL,
        callbackURLScheme: String?,
        presentationContextProvider: ASWebAuthenticationPresentationContextProviding?,
        prefersEphemeralWebBrowserSession: Bool,
        completionHandler: @escaping ASWebAuthenticationSession.CompletionHandler
    ) -> Self {
        self.completionHandler = completionHandler
        return self
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

public class MockFailInternalAuthenticationSession: MockAuthenticationSession {}

public enum TestError: Error {
    case authenticationFail
}

extension URLComponents {
    init?(string: String, queryItems: [URLQueryItem]?) {
        self.init(string: string)
        self.queryItems = queryItems
    }
}
