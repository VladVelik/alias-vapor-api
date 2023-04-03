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
        participantGroup.get(use: getAllHandler)
        participantGroup.get(":participant_id", use: getHandler)
        
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = participantGroup.grouped(basicMW, guardMW)
        protected.post(use: createHandler)
        protected.put(":participant_id", use: updateHandler)
        protected.delete(":participant_id", use: deleteHandler)
    }
    
    //MARK: GET Request /participants route
    func getAllHandler(req: Request) async throws -> [Participant] {
        return try await Participant.query(on: req.db).all()
    }
    
    //MARK: GET Request /participants/id= route
    func getHandler(req: Request) async throws -> Participant {
        guard let participant = try await Participant.find(req.parameters.get("participant_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return participant
    }
    
    //MARK: POST Request /participants route
    func createHandler(req: Request) async throws -> Participant {
        guard let participant = try? req.content.decode(Participant.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        try await participant.save(on: req.db)
        return participant
    }
    
    //MARK: PUT Request /participants/id= route
    func updateHandler(req: Request) async throws -> Participant {
        guard let participant = try await Participant.find(req.parameters.get("participant_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedParticipant = try req.content.decode(Participant.self)
        
        participant.userID = updatedParticipant.userID
        participant.roomID = updatedParticipant.roomID
        participant.teamID = updatedParticipant.teamID
        participant.role = updatedParticipant.role
        try await participant.save(on: req.db)
        return participant
    }
    
    //MARK: DELETE Request /participants/id= route
    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let participant = try await Participant.find(req.parameters.get("participant_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await participant.delete(on: req.db)
        return .ok
    }
}
