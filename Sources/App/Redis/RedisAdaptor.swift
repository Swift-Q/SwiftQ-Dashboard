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
        
        //        self.client = client.run(command: "AUTH", arguments: [RedisData(bulk: password)])
        //            .flatMap(to: RedisClient.self) { data in
        //                client.run(command: "SELECT", arguments: [RedisData(bulk: config.database.description)])
        //                    .flatMap(to: RedisClient.self) { _ in
        //                        promise.complete(client)
        //                        return promise.future
        //                }
        //        }
        
        
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
