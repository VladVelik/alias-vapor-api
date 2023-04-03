//
//  TeamsController.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

struct TeamsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let teamGroup = routes.grouped("teams")
        teamGroup.get(use: getAllHandler)
        teamGroup.get(":team_id", use: getHandler)
        
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = teamGroup.grouped(basicMW, guardMW)
        protected.post(use: createHandler)
        protected.put(":team_id", use: updateHandler)
        protected.delete(":team_id", use: deleteHandler)
    }
    
    //MARK: GET Request /teams route
    func getAllHandler(req: Request) async throws -> [Team] {
        return try await Team.query(on: req.db).all()
    }
    
    //MARK: GET Request /teams/id= route
    func getHandler(req: Request) async throws -> Team {
        guard let team = try await Team.find(req.parameters.get("team_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return team
    }
    
    //MARK: POST Request /teams route
    func createHandler(req: Request) async throws -> Team {
        guard let team = try? req.content.decode(Team.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        try await team.save(on: req.db)
        return team
    }
    
    //MARK: PUT Request /teams/id= route
    func updateHandler(req: Request) async throws -> Team {
        guard let team = try await Team.find(req.parameters.get("team_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedTeam = try req.content.decode(Team.self)
        
        team.roomID = updatedTeam.roomID
        team.name = updatedTeam.name
        team.points = updatedTeam.points
        try await team.save(on: req.db)
        return team
    }
    
    //MARK: DELETE Request /teams/id= route
    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let team = try await Team.find(req.parameters.get("team_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await team.delete(on: req.db)
        return .ok
    }
}
