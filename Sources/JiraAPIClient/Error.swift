//
//  Error.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import Foundation

extension JiraAPIClient {
    enum Error: Swift.Error {
        case invalidAuthURL
        case authorizationCodeNotFound
        case invalidRequest(named: String)
    }
}
