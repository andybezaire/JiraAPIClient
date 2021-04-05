//
//  User.swift
//
//
//  Created by Andy on 5.4.2021.
//

import Foundation
import JiraAPI

public extension JiraAPIClient {
    struct User: Identifiable {
        public let id: String
        public let homepage: URL
        public let avatar: URL
        public let email: String?
        public let name: String
    }
}

extension JiraAPIClient.User {
    init(response: JiraAPI.Models.UserResponse) {
        self.init(
            id: response.id,
            homepage: response.account,
            avatar: response.avatars.first!.value,
            email: response.email,
            name: response.name
        )
    }
}
