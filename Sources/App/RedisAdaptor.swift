//
//  RedisAdaptor.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation
import Redis
import Async

final class RedisAdaptor {
    
    private let client: Future<RedisClient>
    
    init(client: Future<RedisClient>) {
        self.client = client
    }
    
    func retrieve<A>(_ resource: RedisResource<A>) -> Future<RedisData> {
        return client.flatMap(to: RedisData.self) { client in
            return client.run(command: resource.command.rawValue, arguments: resource.command.args)
        }
    }
    
}

protocol RedisRetrievable {
    
    func get() -> RedisResource<Self>
    
}


enum Command {
    
    case get(key: String)
    case mget(keys: [String])
    case llen(key: String)
    case smembers(key: String)
    case lrange(key: String, range: CountableClosedRange<Int>)
    
    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .llen: return "LLEN"
        case .smembers: return "SMEMBERS"
        case .mget: return "MGET"
        case .lrange: return "LRANGE"
        }
    }
    
    var args: [RedisData] {
        switch self {
        case .get(let key): return [RedisData(bulk: key)]
        case .llen(let key): return [RedisData(bulk: key)]
        case .smembers(let key): return [RedisData(bulk: key)]
        case .mget(let keys): return keys.flatMap { RedisData(bulk: $0) }
        case .lrange(let key, let range):
            let lower = String(range.lowerBound)
            let upper = String(range.upperBound)
            return [RedisData(bulk: key), RedisData(bulk: lower), RedisData(bulk: upper)]
        }
    }
}

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
