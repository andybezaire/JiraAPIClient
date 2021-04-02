//
//  SignInTests.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

@testable import JiraAPIClient
import JiraAPIClientTestUtils
import XCTest

final class SignInTests: JiraAPIClientTests {
    func testSignInSuccessful() {
        let signInFinished = XCTestExpectation(description: "Sign in finished")

        let client = JiraAPIClient<MockSuccessAuthenticationSession>(configuration: testConfigS)

        cancellable = client.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // success
                case .failure:
                    XCTFail("Sign in should succeed")
                }
                signInFinished.fulfill()
            })

        wait(for: [signInFinished], timeout: 1)
    }

    func testSignInFailsFromAuthenticationSession() {
        let signInFinished = XCTestExpectation(description: "Sign in finished")

        let client = JiraAPIClient<MockFailAuthenticationSession>(configuration: testConfigF)

        cancellable = client.signIn()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Sign in should fail")
                case .failure(let error):
                    XCTAssertEqual(error as? TestError, TestError.authenticationFail, "error should be from auth")
                    break // success
                }
                signInFinished.fulfill()
            })

        wait(for: [signInFinished], timeout: 1)
    }

    #if !canImport(ObjectiveC)
    static var allTests: [XCTestCaseEntry] = [
        ("testSignInSuccessful", testSignInSuccessful),
        ("testSignInFailsFromAuthenticationSession", testSignInFailsFromAuthenticationSession),
    ]
    #endif
}
