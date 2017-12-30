//
//  OverviewController.swift
//  App
//
//  Created by John Connolly on 2017-12-30.
//

import Foundation
import Vapor
import Leaf

final class OverviewController: Routable {
    
   
    func overview(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        return try leaf.make("overview")
    }
    
    static func routeMap() -> [RouteResource] {
        let controller = self.init()
        return [
            RouteResource(path: "/overview", handler: controller.overview)
        ]
    }
    
}
