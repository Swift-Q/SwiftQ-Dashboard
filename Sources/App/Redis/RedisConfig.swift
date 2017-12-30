//
//  RedisConfig.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation

struct RedisConfig {
    let database: UInt8
    let hostname: String
    let port: UInt16
    let password: String?
    
    
    static var development: RedisConfig {
        return .init(database: 0, hostname: "127.0.0.1", port: 6379, password: nil)
    }
    
}
