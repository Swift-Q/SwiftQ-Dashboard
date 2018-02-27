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
    
    
     func login(_ req: Request) throws -> Future<View> {
        return try req.make(LeafRenderer.self).render("login")
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
