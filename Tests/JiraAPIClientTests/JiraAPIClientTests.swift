//
//  JiraAPIClientTests.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import Combine
@testable import JiraAPIClient
import JiraAPIClientTestUtils
import XCTest

 class JiraAPIClientTests: XCTestCase {
    // MARK: - Configs

    let testConfigS = JiraAPIClient<MockSuccessAuthenticationSession>.Configuration(
        isAuthorizationEphemeral: true,
        clientID: "CLIENT_ID",
        clientSecret: "CLIENT_SECRET",
        scopes: ["SCOPE_1", "SCOPE_2"],
        callbackURLScheme: "CALLBACK-URL-SCHEME",
        callbackURLHost: "CALLBACK_URL_HOST",
        userBoundValue: "USER_BOUND_VALUE"
    )

    let testConfigF = JiraAPIClient<MockFailAuthenticationSession>.Configuration(
        isAuthorizationEphemeral: true,
        clientID: "CLIENT_ID",
        clientSecret: "CLIENT_SECRET",
        scopes: ["SCOPE_1", "SCOPE_2"],
        callbackURLScheme: "CALLBACK-URL-SCHEME",
        callbackURLHost: "CALLBACK_URL_HOST",
        userBoundValue: "USER_BOUND_VALUE"
    )

    let testConfigFI = JiraAPIClient<MockFailInternalAuthenticationSession>.Configuration(
        isAuthorizationEphemeral: true,
        clientID: "CLIENT_ID",
        clientSecret: "CLIENT_SECRET",
        scopes: ["SCOPE_1", "SCOPE_2"],
        callbackURLScheme: "CALLBACK-URL-SCHEME",
        callbackURLHost: "CALLBACK_URL_HOST",
        userBoundValue: "USER_BOUND_VALUE"
    )

    var cancellable: AnyCancellable?

    override func tearDown() {
        cancellable = nil
    }
}
