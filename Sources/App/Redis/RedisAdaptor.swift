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
    
    init(config: RedisConfig, on worker: Worker) throws {
        
        let promise = Promise<RedisClient>()
        let client = try RedisClient.connect(hostname: config.hostname, port: config.port, on: worker)
        
        
        guard let password = config.password else {
            
            client.run(command: "SELECT", arguments: [RedisData(bulk: config.database.description)]).do { _ in
                
                promise.complete(client)
                
                }.catch(promise.fail)
            
            self.client = promise.future
            
            return
        }
        
        client.run(command: "AUTH", arguments: [RedisData(bulk: password)]).do { _ in
            client.run(command: "SELECT", arguments: [RedisData(bulk: config.database.description)]).do { _ in
                
                promise.complete(client)
                
                }.catch(promise.fail)
            
            }.catch(promise.fail)
        
        self.client = promise.future
    }
    
    func execute<A>(_ resource: RedisResource<A>) -> Future<RedisData> {
        return client.flatMap(to: RedisData.self) { client in
            return client.run(command: resource.command.rawValue, arguments: resource.command.args)
        }
    }
    
    func retrieve<A: RedisRetrievable>(_ model: A.Type) -> Future<A?> {
        let resource = model.get()
        let data = client.flatMap(to: RedisData.self) { client in
            return client.run(command: resource.command.rawValue, arguments: resource.command.args)
        }
        return data.map(to: A?.self) { data in
            return resource.transform(data)
        }
    }
    
}


protocol RedisRetrievable {
    
    static func get() -> RedisResource<Self>
    
}
