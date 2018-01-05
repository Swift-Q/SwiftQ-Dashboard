//
//  RedisStats.swift
//  App
//
//  Created by John Connolly on 2018-01-04.
//

import Foundation

final class RedisStats {
    
    let connectedClients: Int
    let blockedClients: Int
    let usedMemoryHuman: String
    let uptime: Int // Seconds
    let usedMemory: Int
    let totalMemory: Int
    
    private let formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    init(_ stats: [String : String]) {
        self.connectedClients = Int(stats["connected_clients"]?.digits ?? "") ?? 0
        self.blockedClients =  Int(stats["blocked_clients"]?.digits ?? "") ?? 0
        self.usedMemoryHuman = stats["used_memory_human"] ?? ""
        self.uptime = Int(stats["uptime_in_seconds"]?.digits ?? "") ?? 0
        self.usedMemory = Int(stats["used_memory"]?.digits ?? "") ?? 0
        self.totalMemory = Int(stats["total_system_memory"]?.digits ?? "") ?? 0
    }
    
    var formattedClients: String {
        return formatter.string(from: NSNumber(integerLiteral: connectedClients)) ?? ""
    }
    
    var formattedBlocked: String {
        return formatter.string(from: NSNumber(integerLiteral: blockedClients)) ?? ""
    }
    
    static func get() -> RedisResource<RedisStats> {
        let command = Command.info(section: .all)
        return RedisResource<RedisStats>(command: command, transformString: { string -> RedisStats in
            return RedisStats(string.parseStats())
        })
    }
    
    var viewResource: RedisStatsView {
        return RedisStatsView(self)
    }
}

protocol Viewable {
    associatedtype Resource: ViewInitializable
}

protocol ViewInitializable {
    
    associatedtype Item
    
    init(_ item: Item)
    
}

struct RedisStatsView: Codable {
    let connectedClients: String
    let blockedClients: String
    let memory: String
    let uptime: String
    let percentage: Int
    
    init(_ redisStats: RedisStats) {
        self.connectedClients = redisStats.formattedClients
        self.blockedClients = redisStats.formattedBlocked
        self.memory = redisStats.usedMemoryHuman
        self.uptime = TimeFormatter(redisStats.uptime).formatted
        self.percentage = 30
    }
    
}

struct TimeFormatter {

    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
    private let format: Format
    
    enum Format {
        case long
        case medium
        case short
    }
    
    init(_ seconds: Int, with format: Format = .short) {
        self.format = format
        self.days = (seconds / 86_400)
        self.hours = (seconds % 86_400) / 3600
        self.minutes = (seconds % 3600) / 60
        self.seconds = (seconds % 3600) % 60
    }
    
    var formatted: String {
        if days > 1 {
            return String(days) + " days"
        }
        
        switch self {
      
        default:
            break
        }
        
        return ""
    }
    
    
}
