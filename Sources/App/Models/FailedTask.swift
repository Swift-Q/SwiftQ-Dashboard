//
//  FailedTask.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation

struct FailedTask: Decodable {
    
    private let taskName: String
    private let worker: String
    private let createdAt: String
    private let errorAt: String
    private let error: String
    
    
    static func get(_ range: CountableClosedRange<Int>) -> RedisResource<[FailedTask]> {
        let command = Command.lrange(key: "logs", range: range)
        return RedisResource<[FailedTask]>(command: command, transformData: { datas -> [FailedTask] in
            return datas.flatMap { data in
                try? JSONDecoder().decode(FailedTask.self, from: data)
            }
        })
    }
    
}
