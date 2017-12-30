//
//  LoginController.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation
import Vapor
import Leaf

final class LoginController: Routable {
    
   
    func login(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        return try leaf.make("login")
    }
    

    static func routeMap() -> [RouteResource] {
        let controller = self.init()
        return [
            RouteResource(path: "/", handler: controller.login)
        ]
    }

}

// Does not work when handler returns ResponseEncodable for some resonse.
struct RouteResource {
    let path: PathComponent
    let handler: (Request) throws -> Future<View>
}

protocol Routable: EmptyInitializable {
    static func routeMap() -> [RouteResource]
}


protocol EmptyInitializable: class {
    init()
}
