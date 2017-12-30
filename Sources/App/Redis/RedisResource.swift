//
//  RedisResource.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation
import Redis

struct RedisResource<A> {
    
    let command: Command
    
    let transform: (RedisData) -> A?
    
}


extension RedisResource {
    
    
    init(command: Command, transformStrings: @escaping ([String]) -> A?) {
        self.command = command
        self.transform = { data in
            let strings = data.array?.flatMap { data  in
                data.string
            }
            return strings.flatMap(transformStrings)
        }
    }
    
    
}
