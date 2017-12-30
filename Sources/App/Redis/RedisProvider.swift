//
//  RedisProvider.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation
import Vapor

final class RedisProvider: Provider {
    
    static var repositoryName = "redis"
    
    func boot(_ worker: Container) throws { }
    
    /// See Service.Provider.Register
    public func register(_ services: inout Services) throws {
        services.register(RedisAdaptor.self) { container -> RedisAdaptor in
            let config = try container.make(RedisConfig.self, for: RedisAdaptor.self)
            return try RedisAdaptor(
                config: config,
                on: container
            )
        }
        
        services.register { container -> RedisConfig in
            return RedisConfig.development
        }
    }
    
}
