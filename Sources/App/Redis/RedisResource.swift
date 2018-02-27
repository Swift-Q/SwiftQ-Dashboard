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
            let strings = data.array?.compactMap { data  in
                data.string
            }
            return strings.flatMap(transformStrings)
        }
    }
    
    init(command: Command, transformOptionalStrings: @escaping ([String?]) -> A?) {
        self.command = command
        self.transform = { data in
            let optionalStrings = data.array?.map { data in
                return data.string
            }
            return optionalStrings.flatMap(transformOptionalStrings)
        }
    }
    
    init(command: Command, transformData: @escaping ([Data]) -> A?) {
        self.command = command
        self.transform = { redisData in
            let datas = redisData.array?.compactMap { $0.data }
            return datas.flatMap(transformData)
        }
    }
    
    init(command: Command, transformString: @escaping (String) -> A?) {
        self.command = command
        self.transform = { data in
            return data.string.flatMap(transformString)
        }
    }
}
