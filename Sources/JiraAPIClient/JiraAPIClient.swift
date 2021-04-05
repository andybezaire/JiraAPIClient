import AuthenticationServices
import Authorization
import Combine
import Foundation
import JiraAPI
import os.log

public class JiraAPIClient<AuthSession>: ObservableObject where AuthSession: AuthenticationSession {
    public init(configuration: Configuration, logger: Logger? = nil) {
        self.config = configuration
        self.logger = logger
    }

    internal let config: Configuration
    lazy var auth: Auth = .init(doGetTokens: doGetTokens, doRefreshToken: doRefreshToken, logger: logger)

    func doGetTokens() -> AnyPublisher<Auth.Tokens, Swift.Error> {
        authorizationCode()
            .flatMap(oauthTokens)
            .eraseToAnyPublisher()
    }

    func doRefreshToken(refresh: Auth.Refresh) -> AnyPublisher<Auth.Tokens, Swift.Error> {
        oauthTokensRefresh(for: refresh)
            .eraseToAnyPublisher()
    }

    @Published var error: Swift.Error?

    var signingIn: AnyCancellable?

    var logger: Logger?

    public func signIn() -> AnyPublisher<Never, Swift.Error> {
        auth.signIn()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }

    var fetchingCloudID: AnyCancellable?

    public func getCloudID() {
        if let request = try? JiraAPI.Request.cloudResources() {

            fetchingCloudID = auth.fetch(request)
                .map(\.data)
                .sink(receiveCompletion: { completion in
                    print("COMPLETED: \(completion)")
                }, receiveValue: { data in
                    let body = String(data: data, encoding: .utf8) ?? "nil"
                    print("BODY: \(body)")
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
