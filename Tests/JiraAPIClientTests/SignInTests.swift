//
//  SignInTests.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

@testable import JiraAPIClient
import JiraAPIClientTestUtils
import Mocker
import XCTest

final class SignInTests: JiraAPIClientTests {
    func testSignInSuccessful() {
        let signInFinished = XCTestExpectation(description: "Sign in finished")

        let client = JiraAPIClient(
            configuration: configuration,
            logger: logger,
            authenticationSession: MockSuccessAuthenticationSession()
        )

        let url = URL(string: "https://auth.atlassian.com/oauth/token")!
        let data = #"{"access_token":"ACCESS_TOKEN","refresh_token":"REFRESH_TOKEN"}"#
            .data(using: .utf8)!
        
        Mock(url: url, dataType: .json, statusCode: 200, data: [.post: data])
            .register()
        
        let resourcesURL = URL(string: "https://api.atlassian.com/oauth/token/accessible-resources")!
        let resourcesData = """
        [
          {
            "id": "1324a887-45db-1bf4-1e99-ef0ff456d421",
            "name": "Site name",
            "url": "https://your-domain.atlassian.net",
            "scopes": [
              "write:jira-work",
              "read:jira-user",
              "manage:jira-configuration"
            ],
            "avatarUrl": "https://site-admin-avatar-cdn.prod.public.atl-paas.net/avatars/240/flag.png"
          }
        ]
        """
            .data(using: .utf8)!
        
        Mock(url: resourcesURL, dataType: .json, statusCode: 200, data: [.get: resourcesData])
            .register()
        
        let userProfileURL = URL(string: "https://api.atlassian.com/me")!
        let userData = """
        {
          "account_type": "atlassian",
          "account_id": "112233aa-bb11-cc22-33dd-445566abcabc",
          "email": "mia@example.com",
          "name": "Mia Krystof",
          "picture": "https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/112233aa-bb11-cc22-33dd-445566abcabc/1234abcd-9876-54aa-33aa-1234dfsade9487ds",
          "account_status": "active",
          "nickname": "mkrystof",
          "zoneinfo": "Australia/Sydney",
          "locale": "en-US",
          "extended_profile": {
            "job_title": "Designer",
            "organization": "mia@example.com",
            "department": "Design team",
            "location": "Sydney"
          }
        }
        """
            .data(using: .utf8)!
        
        Mock(url: userProfileURL, dataType: .json, statusCode: 200, data: [.get: userData])
            .register()
        
        cancellable = client.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // success
                case .failure(let error):
                    print("ERROR: \(error)")
                    XCTFail("Sign in should succeed")
                }
                signInFinished.fulfill()
            })

        wait(for: [signInFinished], timeout: 5)
    }

    func testSignInFailsFromAuthenticationSession() {
        let signInFinished = XCTestExpectation(description: "Sign in finished")

        let client = JiraAPIClient(configuration: configuration, authenticationSession: MockFailAuthenticationSession())

        cancellable = client.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Sign in should fail")
                case .failure(let error):
                    XCTAssertEqual(error as? TestError, TestError.authenticationFail, "error should be from auth")
                    // success
                }
                signInFinished.fulfill()
            })

        wait(for: [signInFinished], timeout: 1)
    }

    func testSignInFailsFromInternalAuthenticationSession() {
        let signInFinished = XCTestExpectation(description: "Sign in finished")

        let client = JiraAPIClient(
            configuration: configuration,
            authenticationSession: MockFailInternalAuthenticationSession()
        )

        cancellable = client.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Sign in should fail")
                case .failure(let error):
                    XCTAssertEqual(
                        error as? JiraAPIClient.Error,
                        JiraAPIClient.Error.authorizationCodeInternalError,
                        "error should be from auth"
                    )
                    // success
                }
                signInFinished.fulfill()
            })

        wait(for: [signInFinished], timeout: 1)
    }

    #if !canImport(ObjectiveC)
    static var allTests: [XCTestCaseEntry] = [
        ("testSignInSuccessful", testSignInSuccessful),
        ("testSignInFailsFromAuthenticationSession", testSignInFailsFromAuthenticationSession),
        ("testSignInFailsFromInternalAuthenticationSession", testSignInFailsFromInternalAuthenticationSession),
    ]
    #endif
}
