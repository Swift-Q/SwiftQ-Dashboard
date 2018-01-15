//
//  RedisAdaptor.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation
import Redis
import Async
import Service

final class RedisAdaptor: Service {
    
    private let client: Future<RedisClient>
    
    init(config: RedisConfig, on worker: Worker) throws {
        
        let promise = Promise<RedisClient>()
        let client = try RedisClient.connect(hostname: config.hostname, port: config.port, on: worker)
        
        
        guard let password = config.password else {
            
            client.command("SELECT", [RedisData(bulk: config.database.description)]).do { _ in
                
                promise.complete(client)
                
                }.catch(promise.fail)
            
            self.client = promise.future
            
            return
        }
        
        client.command("AUTH", [RedisData(bulk: password)]).do { _ in
            client.command("SELECT", [RedisData(bulk: config.database.description)]).do { _ in
                
                promise.complete(client)
                
                }.catch(promise.fail)
            
            }.catch(promise.fail)
        
        self.client = promise.future
    }
    
    func execute<A>(_ resource: RedisResource<A>) -> Future<RedisData> {
        return client.flatMap(to: RedisData.self) { client in
            return client.command(resource.command.rawValue, resource.command.args)
        }
    }
    
    func retrieve<A: RedisRetrievable>(_ model: A.Type) -> Future<A?> {
        let resource = model.get()
        let data = client.flatMap(to: RedisData.self) { client in
            return client.command(resource.command.rawValue, resource.command.args)
        }
        return data.map(to: A?.self) { data in
            return resource.transform(data)
        }
    }
    
    func retrieve<A>(_ resource: RedisResource<A>) -> Future<A?> {
        let data = client.flatMap(to: RedisData.self) { client in
            return client.command(resource.command.rawValue, resource.command.args)
        }
        return data.map(to: A?.self) { data in
            return resource.transform(data)
        }
    }
    
    
}


protocol RedisRetrievable {
    
    static func get() -> RedisResource<Self>
    
}



