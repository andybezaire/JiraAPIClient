//
//  JiraAPIClientTests.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import Combine
@testable import JiraAPIClient
import JiraAPIClientTestUtils
import os.log
import XCTest

class JiraAPIClientTests: XCTestCase {
    // MARK: - Configs

    let configuration = JiraAPIClient.Configuration(
        isAuthorizationEphemeral: true,
        clientID: "CLIENT_ID",
        clientSecret: "CLIENT_SECRET",
        scopes: ["SCOPE_1", "SCOPE_2"],
        callbackURLScheme: "CALLBACK-URL-SCHEME",
        callbackURLHost: "CALLBACK_URL_HOST",
        userBoundValue: "USER_BOUND_VALUE"
    )

    var cancellable: AnyCancellable?

    let logger = Logger(subsystem: "com.example.jiraapiclient", category: "JiraAPIClientTests")

    override func tearDown() {
        cancellable = nil
    }
}
