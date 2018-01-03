//
//  OverviewController.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation
import Vapor
import Leaf

final class DashboardController {
    
    // TODO: Figure out a way to simplify this.
    private func overview(_ req: Request) throws -> Future<View> {
        let client = try req.make(RedisAdaptor.self)
        
        return client
            .retrieve(Consumers.self)
            .flatMap(to: View.self) { consumers in
                return consumers!  // Throw in retrive function so this is not an optional.
                    .names
                    .flatMap { name -> Future<Consumer?> in
                        return client.retrieve(Consumer.get(with: name))
                    }
                    .flatten()
                    .map(to: Analytics.self) { consumers in
                        return Analytics(consumers: consumers.flatMap { $0 })
                    }.flatMap(to: View.self) { analytics in
                        try req.make(LeafRenderer.self).make("overview", AnalyticsView(analytics))
                }
        }
    }
    
    // TODO: Remove session
    private func logout(_ req: Request) throws -> Response {
        return req.redirect(to: "/")
    }
    
    private func failed(_ req: Request) throws -> Future<View> {
        return try req.make(LeafRenderer.self).make("failed")
    }

    
}

extension DashboardController: Controllable {
    
    func register(with router: Router) {
        router.get("/overview", use: overview)
        router.get("/logout", use: logout)
        router.get("/failed", use: failed)
    }
    
}
