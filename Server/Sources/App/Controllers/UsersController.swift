//
//  UsersController.swift
//  
//
//  Created by Никита Лисунов on 30.03.2023.
//

import Fluent
import Vapor

struct UsersController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let usersGroup = routes.grouped("users")
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = usersGroup.grouped(basicMW, guardMW)
        
        protected.put("auth", use: updateLoginStatusHandler)
        usersGroup.post("register", use: registerHandler)
    }
    
    // MARK: - AUTHORISATION / UNAUTH (PUT Request /users/auth route)
    func updateLoginStatusHandler(req: Request) async throws -> User.Public {
        let auth_user = try req.auth.require(User.self)
        
        struct Context: Content {
            var login_status: Bool
        }
        
        let login_status = try req.content.decode(Context.self)
        
        auth_user.login_status = login_status.login_status
        try await auth_user.save(on: req.db)
        return auth_user.converToPublic()
    }
    
    //MARK: - REGISTRATION (POST Request /users/register route)
    func registerHandler(req: Request) async throws -> User.Public {
        guard let user = try? req.content.decode(User.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.converToPublic()
    }
}
