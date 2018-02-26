import Vapor
import Leaf
import Redis

/// Called before your application initializes.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#configureswift)
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    let leaf = LeafProvider()
    try services.register(leaf)
    
    let adaptor = RedisProvider()
    try services.register(adaptor)
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    let redis = Redis.RedisProvider()
    try services.register(redis)

}

