//
//  User.swift
//
//
//  Created by Andy on 5.4.2021.
//

import Foundation
import JiraAPI

public extension JiraAPIClient {
    struct UserProfile: Identifiable {
        public let id: String
        public let picture: URL?
        public let email: String?
        public let name: String
    }
}

extension JiraAPIClient.UserProfile {
    init(response: JiraAPI.Models.MeResponse) {
        self.init(
            id: response.id,
            picture: response.picture,
            email: response.email,
            name: response.name
        )
    }
}
