//
//  RedisController.swift
//  App
//
//  Created by John Connolly on 2018-02-24.
//

import Foundation
import Redis
import Async
import Vapor

final class RedisController {
    
    struct Car: Content {
        let wheels: Int
        let color: String
        let horsepower: Int
        let brand: String
    }
    
    
    func test(_ req: Request) throws -> Future<Car> {
//      let client = try req.make(RedisClient.self)
        
        return Future(Car(wheels: 4, color: "Red", horsepower: 400, brand: "Ford"))
//      return try client.get(Car.self, forKey: "car").unwrap(or: "ERROR")
    }
    
}

