//
//  LoginController.swift
//  App
//
//  Created by John Connolly on 2017-12-29.
//

import Foundation
import Vapor
import Leaf

final class LoginController {
    
    
    private func login(_ req: Request) throws -> Future<View> {
        let leaf = try req.make(LeafRenderer.self)
        return try leaf.make("login")
    }

}

extension LoginController: Controllable {
    
    func register(with router: Router) {
        router.get("/", use: login)
    }
    
}

protocol Controllable: EmptyInitializable {
    func register(with router: Router)
}


protocol EmptyInitializable: class {
    init()
}
