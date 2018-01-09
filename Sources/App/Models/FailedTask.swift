//
//  FailedTask.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation
// TODO: Rename message to error
final class FailedTask: Codable {
    
    let storage: Storage
    
    struct Storage: Codable {
        let retryCount: Int
        let taskType: String
        let name: String
        let enqueuedAt: Int
        let uuid: String
        let log: Log
        
        struct Log: Codable {
            let message: String
            let consumer: String
            let date: Int
        }
        
    }
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    var enqueued: String {
        let date = Date(timeIntervalSince1970: Double(storage.enqueuedAt))
        return formatter.string(from: date)
    }
    
    var errorAt: String {
        let date = Date(timeIntervalSince1970: Double(storage.log.date))
        return formatter.string(from: date)
    }
    
    static func get(_ range: CountableClosedRange<Int>) -> RedisResource<[FailedTask]> {
        let command = Command.lrange(key: "logs", range: range)
        return RedisResource<[FailedTask]>(command: command, transformData: { datas -> [FailedTask] in
            return datas.flatMap { data in
                return handle {
                    return try JSONDecoder().decode(FailedTask.self, from: data)
                }
            }
        })
    }
    
    var viewResource: FailedTaskView {
        return FailedTaskView(self)
    }
    
}
