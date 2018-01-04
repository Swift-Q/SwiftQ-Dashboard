//
//  RedisStats.swift
//  App
//
//  Created by John Connolly on 2018-01-04.
//

import Foundation

struct RedisStats {
    
    let connectedClients: Int
    let blockedClients: Int
    let usedMemory: String
    let uptime: Int // Seconds
    
    init(_ stats: [String : String]) {
        self.connectedClients = Int(stats["connected_clients"]?.digits ?? "") ?? 0
        self.blockedClients =  Int(stats["blocked_clients"]?.digits ?? "") ?? 0
        self.usedMemory = stats["used_memory_human"] ?? ""
        self.uptime = Int(stats["uptime_in_seconds"]?.digits ?? "") ?? 0
    }
    
    static func get() -> RedisResource<RedisStats> {
        let command = Command.info(section: .all)
        return RedisResource<RedisStats>(command: command, transformString: { string -> RedisStats in
            return RedisStats(string.parseStats())
        })
    }
}
