//
//  Consumer.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation

struct Consumer {
    
    let name: String
    let successful: Int
    let failed: Int
    let queued: Int
    
    private let formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    init(name: String, results: [String?]) {
        self.name = name
        let integers = results.flatMap { Int($0 ?? "0") }
        self.successful = integers[safe: 0] ?? 0
        self.failed = integers[safe: 1] ?? 0
        self.queued = 0
    }
    
    var formattedSuccessful: String {
        return formatter.string(from: NSNumber(integerLiteral: successful)) ?? ""
    }
    
    var formattedFailed: String {
        return formatter.string(from: NSNumber(integerLiteral: failed)) ?? ""
    }
    
    
    static func get(with name: String) -> RedisResource<Consumer> {
        let command = Command.mget(keys: [(name + ":s"), (name + ":f")])
        //  let listCommand = Command.llen(key: name + ":pq")
        
        return RedisResource<Consumer>(command: command) { results -> Consumer in
            return Consumer(name: name, results: results)
        }
    }
    
    var viewResource: ConsumerView {
        return ConsumerView(self)
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

protocol ViewRepresentable {
    var resource: ViewResource { get }
}

protocol ViewResource: Codable { }
