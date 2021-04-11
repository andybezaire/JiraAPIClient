//
//  Error.swift
//
//
//  Created by Andy Bezaire on 2.4.2021.
//

import Foundation

public extension JiraAPIClient {
    enum Error: Swift.Error {
        case invalidAuthURL
        case authorizationCodeNotFound
        case authorizationCodeInternalError
        case invalidOauthTokenRequest
        case oauthTokenRequestFailure
        case oauthTokenDecodeFailure
        case noCurrentResourceID
    }
}

extension JiraAPIClient.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidAuthURL:
            return "Invalid authorization url."
        case .authorizationCodeNotFound:
            return "Authorization code not found in payload."
        case .authorizationCodeInternalError:
            return "Internal error while reveiving authentication code."
        case .invalidOauthTokenRequest:
            return "Invalid oauth token request."
        case .oauthTokenRequestFailure:
            return "Failure during oauth token request."
        case .oauthTokenDecodeFailure:
            return "Failure decoding oauth token from payload."
        case .noCurrentResourceID:
            return "Can't access any resources."
        }
    }
}
