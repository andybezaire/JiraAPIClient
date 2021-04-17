//
//  File.swift
//  
//
//  Created by Andy on 17.4.2021.
//

import Foundation
import SwiftUI

class UserProfileViewModel: ObservableObject {
    let client: JiraAPIClient
    
    @Published var profile: JiraAPIClient.UserProfile?
    @Published var resources: [JiraAPIClient.Resource] = []
    @Published var selectedResource: JiraAPIClient.Resource?
    
    init(client: JiraAPIClient) {
        self.client = client
        
        client.userProfile
            .receive(on: RunLoop.main)
            .assign(to: &$profile)
        
        client.resources
            .receive(on: RunLoop.main)
            .assign(to: &$resources)
        
        client.cloudID
            .map { cloudID in
                self.resources.first { $0.id == cloudID }
            }
            .receive(on: RunLoop.main)
            .assign(to: &$selectedResource)

    }
}
