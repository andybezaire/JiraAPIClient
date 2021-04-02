import Foundation
import Authorization
import Combine

public class JiraAPIClient: ObservableObject {
    public init(configuration: Configuration) {
        self.config = configuration
    }
    
    internal let config: Configuration
    lazy var auth: Auth = .init(doGetTokens: doGetTokens, doRefreshToken: doRefreshToken)

    func doGetTokens() -> AnyPublisher<Auth.Tokens, Swift.Error> {
        fatalError()
    }

    func doRefreshToken(refresh: Auth.Refresh) -> AnyPublisher<Auth.Tokens, Swift.Error> {
        fatalError()
    }

    @Published var error: Swift.Error?

    var signingIn: AnyCancellable?

    public func signIn() {
        signingIn = auth.signIn()
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    self.error = error
                case .finished:
                    print("signed in")
                    self.error = nil
                }
            }, receiveValue: { (_) in
                print("value???")
            })
    }
}
