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
        usersGroup.get(use: getAllHandler)
        usersGroup.post(use: createHandler)
        usersGroup.get(":user_id", use: getHandler)
        
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = usersGroup.grouped(basicMW, guardMW)
        protected.put(":user_id", use: updateHandler)
        protected.delete(":user_id", use: deleteHandler)
    }
    
    //MARK: GET Request /users route
    func getAllHandler(req: Request) async throws -> [User.Public] {
        let users = try await User.query(on: req.db).all()
        let publics = users.map { user in
            user.converToPublic()
        }
        return publics
    }
    
    //MARK:  GET Request /users/id= route
    func getHandler(req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("user_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user.converToPublic()
    }
    
    //MARK: POST Request /users route
    func createHandler(req: Request) async throws -> User.Public {
        guard let user = try? req.content.decode(User.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        user.password = try Bcrypt.hash(user.password)
        try await user.save(on: req.db)
        return user.converToPublic()
    }
    
    //MARK: PUT Request /users/id= route
    func updateHandler(req: Request) async throws -> User.Public {
        guard let user = try await User.find(req.parameters.get("user_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedUser = try req.content.decode(User.self)
        
        user.username = updatedUser.username
        user.email = updatedUser.email
        user.password = updatedUser.password
        try await user.save(on: req.db)
        return user.converToPublic()
    }
    
    //MARK: DELETE Request /users/id= route
    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("user_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
}
