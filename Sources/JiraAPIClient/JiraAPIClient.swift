import AuthenticationServices
import Authorization
import Combine
import Foundation
import JiraAPI
import os.log

public class JiraAPIClient<AuthSession> where AuthSession: AuthenticationSession {
    public init(configuration: Configuration, logger: Logger? = nil, authLogger: Logger? = nil, auth: Auth? = nil) {
        self.config = configuration
        self.logger = logger
        self.authLogger = authLogger ?? logger
        auth.map { self.auth = $0 }
    }

    internal let config: Configuration

    lazy internal var auth: Auth = .init(doGetTokens: doGetTokens, doRefreshToken: doRefreshToken, logger: authLogger)

    var logger: Logger?
    
    var authLogger: Logger?

    public var user: CurrentUser = .init()

    public var resource: Resource?
    
    @Published public var error: Swift.Error?

    internal var signingInOut: AnyCancellable?
    internal var fetchingCloudID: AnyCancellable?
    internal var fetchingMyself: AnyCancellable?

    @Published public var cloudID: JiraAPI.Auth.CloudID?


    public func getCloudID() {
        if let request = try? JiraAPI.Request.cloudResources() {
            fetchingCloudID = auth.fetch(request)
                .map(\.data)
                .decode(type: [JiraAPI.Models.CloudResourceResponse].self, decoder: JSONDecoder())
                .map(\.first)
                .map { $0! }
                .map(Resource.init)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    print("COMPLETED: \(completion)")
                }, receiveValue: { [unowned self] resource in
                    cloudID = resource.id
                    user.update(with: [resource])
                    print("RESOURCE NAME: \(resource.name)")
                })
        } else {
            print("big error")
        }
    }

    public func getMyself() {
        if let cloudID = cloudID, let request = try? JiraAPI.Request.myself(cloudID: cloudID) {
            fetchingCloudID = auth.fetch(request)
                .map(\.data)
                .decode(type: JiraAPI.Models.UserResponse.self, decoder: JSONDecoder())
                .map(User.init)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    print("COMPLETED: \(completion)")
                }, receiveValue: { [unowned self] in
                    user.update(with: $0)
                })
        } else {
            print("big error")
        }
    }
}

public extension JiraAPIClient {
    /// Force refresh of the authorization tokens. This is intended to be used while debugging and not for normal use.
    func forceTokenRefresh() {
        auth.forceTokenRefresh()
    }
}
