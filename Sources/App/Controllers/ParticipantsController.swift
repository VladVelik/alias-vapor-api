//
//  ParticipantsController.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

struct ParticipantsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let participantGroup = routes.grouped("participants")
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = participantGroup.grouped(basicMW, guardMW)

        protected.put("role", use: updateRoleHandler)
        protected.delete("fromTeam", ":user_id", use: deleteFromTeamHandler)
        protected.delete("fromRoom", ":user_id", use: deleteFromRoomHandler)
    }
    
    // MARK: - CHANGE ROLE (PUT Request /participants/role route)
    func updateRoleHandler(req: Request) async throws -> Participant {
        struct Context: Content {
            var user_id: UUID
            var role: String
        }
        
        let context = try req.content.decode(Context.self)
        
        let auth_user = try req.auth.require(User.self)
        
        guard let participant = try await Participant.query(on: req.db)
            .filter(\.$userID == auth_user.id!)
            .filter(\.$role == "admin")
            .first()
        else {
            throw Abort(.notFound)
        }
        
        guard let participant = try await Participant.query(on: req.db)
            .filter(\.$userID == context.user_id)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        if participant.userID != auth_user.id {
            participant.role = context.role
            try await participant.save(on: req.db)
        }
        return participant
    }
    
    //MARK: DELETE PARTICIPANT FROM TEAM (DELETE Request /participants/fromTeam/id route)
    func deleteFromTeamHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("user_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let auth_user = try req.auth.require(User.self)
        
        guard let participant_admin = try await Participant.query(on: req.db)
            .filter(\.$userID == auth_user.id!)
            .filter(\.$role == "admin")
            .first()
        else {
            throw Abort(.notFound)
        }
        if user.id != auth_user.id {
            let participant = try await Participant.query(on: req.db)
                .filter(\.$userID == user.id!)
                .first()
            participant!.teamID = nil
            try await participant!.save(on: req.db)
            return .ok
        } else {
            return .badRequest
        }
    }
    
    //MARK: DELETE PARTICIPANT FROM ROOM (DELETE Request /participants/fromRoom/id route)
    func deleteFromRoomHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("user_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let auth_user = try req.auth.require(User.self)
        
        guard let participant_admin = try await Participant.query(on: req.db)
            .filter(\.$userID == auth_user.id!)
            .filter(\.$role == "admin")
            .first()
        else {
            throw Abort(.notFound)
        }
        if user.id != auth_user.id {
            let participant = try await Participant.query(on: req.db)
                .filter(\.$userID == user.id!)
                .first()
            try await participant!.delete(on: req.db)
            return .ok
        } else {
            return .badRequest
        }
    }
}