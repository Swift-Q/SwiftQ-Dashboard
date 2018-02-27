//
//  OverviewController.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation
import Vapor
import Leaf
import Terse
import Redis

final class DashboardController {
    
    
    private func overview(_ req: Request) throws -> Future<View> {
        let client = try req.make(RedisAdaptor.self)
        let consumers = client
            .retrieve(Consumers.self)
            .unwrap(or: "Redis Error")
            .flatMap(to: [Consumer?].self) { consumer in
                consumer.names.compactMap { name -> Future<Consumer?> in
                    return client.retrieve(Consumer.get(with: name))
                    }.flatten()
        }
        
        let overview = consumers
            <^> Analytics.init
            <^> AnalyticsView.init
            <^> curry(Overview.init)
        
        let stats = client.retrieve(RedisStats.get()).unwrap(or: "Redis error") <^> RedisStatsView.init
  
        let renderer: (String, Encodable) -> Future<View> = try req.make(LeafRenderer.self).render
        return overview <*> stats >>- curry(renderer)("overview")
    }
    
    // TODO: Remove session
    private func logout(_ req: Request) throws -> Response {
        return req.redirect(to: "/")
    }
    
    private func failed(_ req: Request) throws -> Future<View> {
        let client = try req.make(RedisAdaptor.self)
        let tasks = client.retrieve(FailedTask.get(0...10)) ?? []
        return tasks
            .map(to: [FailedTaskView].self) { tasks in
                return tasks.map { $0.viewResource }
            }.flatMap(to: View.self) { views in
                return try req.make(LeafRenderer.self).render("failed", ["tasks": views])
        }
    }
    
}

extension DashboardController: Controllable {
    
    func register(with router: Router) {
        router.get("/overview", use: overview)
        router.get("/logout", use: logout)
        router.get("/failed", use: failed)
    }
    
}


infix operator <*>: MonadicPrecedenceLeft
public func <*> <T, U>(f: Future<((T?) -> U)>, a: Future<T>) -> Future<U> {
    return f.flatMap(to: U.self) { f in
        return a <^> f
    }
}

public func <*> <T, U>(f: Future<((T) -> U)>, a: Future<T>) -> Future<U> {
    return f.flatMap(to: U.self) { f in
        return a <^> f
    }
}

