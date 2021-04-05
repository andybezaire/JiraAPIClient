//
//  CurrentUser.swift
//
//
//  Created by Andy on 5.4.2021.
//

import Foundation

public extension JiraAPIClient {
    class CurrentUser: ObservableObject {
        public var name: String? { user?.name }
        public var email: String? { user?.email }
        
        var user: User? {
            willSet {
                objectWillChange.send()
            }
        }

        var resources: [Resource] {
            willSet {
                objectWillChange.send()
            }
        }

        init(user: User? = nil, resources: [Resource] = []) {
            self.user = user
            self.resources = resources
        }

        func update(with user: User) {
            self.user = user
        }

        func update(with resources: [Resource]) {
            self.resources = resources
        }
    }
}
