import XCTest

import JiraAPIClientTests

var tests = [XCTestCaseEntry]()
tests += SignInTests.allTests()
XCTMain(tests)
