//
//  Command.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation
import Redis

enum Command {
    
    enum Section: String {
        case clients
        case memory
        case server
        case all
    }
    
    case get(key: String)
    case mget(keys: [String])
    case llen(key: String)
    case smembers(key: String)
    case lrange(key: String, range: CountableClosedRange<Int>)
    case info(section: Section)
    
    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .llen: return "LLEN"
        case .smembers: return "SMEMBERS"
        case .mget: return "MGET"
        case .lrange: return "LRANGE"
        case .info: return "INFO"
        }
    }
    
    var args: [RedisData] {
        switch self {
        case .get(let key): return [RedisData(bulk: key)]
        case .llen(let key): return [RedisData(bulk: key)]
        case .smembers(let key): return [RedisData(bulk: key)]
        case .mget(let keys): return keys.flatMap { RedisData(bulk: $0) }
        case .info(let section):
            switch section {
            case .all: return []
            default: return [RedisData(bulk: section.rawValue.uppercased())]
            }
        case .lrange(let key, let range):
            let lower = String(range.lowerBound)
            let upper = String(range.upperBound)
            return [RedisData(bulk: key), RedisData(bulk: lower), RedisData(bulk: upper)]
        }
    }
}
