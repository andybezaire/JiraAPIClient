//
//  Resource.swift
//
//
//  Created by Andy on 5.4.2021.
//

import Foundation
import JiraAPI

public extension JiraAPIClient {
    struct Resource: Identifiable {
        public let id: JiraAPI.Auth.CloudID
        public let name: String
        public let homepage: URL
        public let scopes: [JiraAPI.Auth.Scope]
        public let avatar: URL
    }
}

extension JiraAPIClient.Resource {
    init(response: JiraAPI.Models.CloudResourceResponse) {
        self.init(
            id: response.cloudID,
            name: response.name,
            homepage: response.url,
            scopes: response.scopes,
            avatar: response.avatar
        )
    }
}
