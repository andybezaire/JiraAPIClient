import XCTest

import JiraAPIClientTests

var tests = [XCTestCaseEntry]()
tests += JiraAPIClientTests.allTests()
XCTMain(tests)
