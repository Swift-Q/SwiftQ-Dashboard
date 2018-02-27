import Routing
import Vapor

private let controllers: [Controllable.Type] = [
    LoginController.self,
    DashboardController.self
]

public func routes(_ router: Router) throws {
    controllers.forEach { $0.init().register(with: router) }
}
