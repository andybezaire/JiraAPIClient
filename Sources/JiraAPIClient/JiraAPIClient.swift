import AuthenticationServices
import Authorization
import Combine
import Foundation

public class JiraAPIClient<AuthSession>: ObservableObject where AuthSession: AuthenticationSession {
    public init(configuration: Configuration) {
        self.config = configuration
    }

    internal let config: Configuration
    lazy var auth: Auth = .init(doGetTokens: doGetTokens, doRefreshToken: doRefreshToken)

    func doGetTokens() -> AnyPublisher<Auth.Tokens, Swift.Error> {
        authorizationCode()
            .map { code in
                Auth.Tokens(token: "TOKEN from: \(code)", refresh: "REFRESH from: \(code)")
            }
            .eraseToAnyPublisher()
    }

    func doRefreshToken(refresh: Auth.Refresh) -> AnyPublisher<Auth.Tokens, Swift.Error> {
        fatalError()
    }

    @Published var error: Swift.Error?

    var signingIn: AnyCancellable?

    public func signIn() -> AnyPublisher<Void, Swift.Error> {
        auth.signIn()
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }
}
