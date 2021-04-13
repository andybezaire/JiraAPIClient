import Authorization
import Combine
import Foundation
import JiraAPI
import AuthenticationServices
import os.log

public class JiraAPIClient {
    public init(
        configuration: Configuration,
        logger: Logger? = nil,
        authLogger: Logger? = nil,
        auth: Auth? = nil,
        authenticationSession: AuthenticationSession = AuthenticationSession()
    ) {
        self.config = configuration
        self.logger = logger
        self.authLogger = authLogger ?? logger
        self.authenticationSession = authenticationSession
        auth.map { self.auth = $0 }
    }

    let config: Configuration
    
    let logger: Logger?
    let authLogger: Logger?
    
    let authenticationSession: AuthenticationSession
    
    lazy internal var auth: Auth = .init(doGetTokens: doGetTokens, doRefreshToken: doRefreshToken, logger: authLogger)

    var signingInOut: AnyCancellable?
    
    let _resources = CurrentValueSubject<[Resource], Never>([])
    public var resources: AnyPublisher<[Resource], Never> {
        _resources
            .eraseToAnyPublisher()
    }
    
    let cloudID: CurrentValueSubject<JiraAPI.Auth.CloudID?, Never> = .init(nil)
    
    let _userProfile = CurrentValueSubject<UserProfile?, Never>(nil)
    public var userProfile: AnyPublisher<UserProfile?, Never> {
        _userProfile
            .eraseToAnyPublisher()
    }
}



public extension JiraAPIClient {
    /// Force refresh of the authorization tokens. This is intended to be used while debugging and not for normal use.
    func forceTokenRefresh() {
        auth.forceTokenRefresh()
    }
}
