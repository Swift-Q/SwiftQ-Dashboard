//
//  Consumers.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation

struct Consumers: RedisRetrievable {
    
    let names: [String]
    
    static func get() -> RedisResource<Consumers> {
        let command = Command.smembers(key: "consumers")
        return RedisResource<Consumers>(command: command) { names -> Consumers in
            return Consumers(names: names)
        }
    }
    
}
