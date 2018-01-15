//
//  Overview.swift
//  App
//
//  Created by John Connolly on 2018-01-09.
//

import Foundation

struct Overview: Codable {
    
    let analytics: AnalyticsView
    let redisStats: RedisStatsView?
    
}


struct AnalyticsView: Codable {
    
    let successful: String
    let failed: String
    let queued: String
    let workers: [ConsumerView]
    
    init(_ analytics: Analytics) {
        self.successful = analytics.formattedSuccessful
        self.failed = analytics.formattedFailed
        self.queued = analytics.queued.description
        self.workers = analytics.consumers.map { $0.viewResource }
    }
    
}

struct ConsumerView: ViewResource {
    let name: String
    let successful: String
    let failed: String
    
    init(_ consumer: Consumer) {
        self.name = consumer.name
        self.successful = consumer.formattedSuccessful
        self.failed = consumer.formattedFailed
    }
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
