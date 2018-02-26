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
    
    // TODO: Figure out a way to simplify this.
    private func overview(_ req: Request) throws -> Future<View> {
        let client = try req.make(RedisAdaptor.self)
        return client
            .retrieve(Consumers.self)
            .flatMap(to: View.self) { consumers in
                return consumers!  // Throw in retrive function so this is not an optional.
                    .names
                    .compactMap { name -> Future<Consumer?> in
                        return client.retrieve(Consumer.get(with: name))
                    }
                    .flatten()
                    .map(to: Analytics.self) { consumers in
                        return Analytics(consumers: consumers.compactMap { $0 })
                    }.flatMap(to: View.self) { analytics in
                        return client.retrieve(RedisStats.get())
                            .map(to: RedisStatsView?.self) { stats in
                                return stats?.viewResource
                            }.flatMap(to: View.self) { stats in
                                let overview = Overview(analytics:  AnalyticsView(analytics), redisStats: stats)
                                return try req.make(LeafRenderer.self).render("overview", overview)
                        }
                }
        }
    }
    
    private func loadTest(_ req: Request) throws -> Future<RedisResponse> {
        let client = try req.make(RedisClient.self)
        
        return client.command("LPOP", ["myList"])
            >>-  curry(get)(client)
            <^> RedisResponse.init
    }
    
    struct RedisResponse: Encodable {
        init(_ resp: RedisData) { }
    }
    
    private func terse(_ req: Request) throws -> Future<RedisResponse> {
        let client = try req.make(RedisClient.self)
        return get(with: client, for: "KEY")
            >>-  curry(get)(client)
            >>-  curry(get)(client)
            >>-  curry(get)(client)
            <^> RedisResponse.init
    }
   
    func get(with client: RedisClient, for data: RedisData) -> Future<RedisData> {
        return client.command("GET", [data])
    }
    
    
    //  let renderer: (String, Encodable) -> Future<View> = try req.make(LeafRenderer.self).render
    
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
