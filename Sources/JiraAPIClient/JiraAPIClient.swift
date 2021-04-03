import AuthenticationServices
import Authorization
import Combine
import Foundation
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
        fatalError()
    }

    @Published var error: Swift.Error?

    var signingIn: AnyCancellable?

    var logger: Logger?

    public func signIn() -> AnyPublisher<Never, Swift.Error> {
        auth.signIn()
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
