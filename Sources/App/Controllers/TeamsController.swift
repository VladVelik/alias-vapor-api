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
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = teamGroup.grouped(basicMW, guardMW)
        
        protected.put("enter", use: enterTeamHandler)
        protected.post("create", use: createTeamHandler)
        protected.get(":room_id", use: getAllTeamsOfRoomHandler)
        protected.get("users", ":room_id", use: getUsersOfTeamHandler)
        protected.put("addPoints", "team_id", use: addPointsHandler)
        protected.delete(":room_id", use: deleteTeamsHandler)
    }
    
    // MARK: - ENTER A TEAM (PUT Request /teams/enter route)
    func enterTeamHandler(req: Request) async throws -> Participant {
        let auth_user = try req.auth.require(User.self)
        
        struct Context: Content {
            var teamID: UUID
        }
        
        guard let participant = try await Participant.query(on: req.db)
            .filter(\.$userID == auth_user.id!)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        let teamID = try req.content.decode(Context.self)
        
        participant.teamID = teamID.teamID
        try await participant.save(on: req.db)
        return participant
    }
    
    //MARK: - CREATE TEAM (POST Request /teams/create route)
    func createTeamHandler(req: Request) async throws -> Team {
        guard let team = try? req.content.decode(Team.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        
        let auth_user = try req.auth.require(User.self)
        guard let participant_admin = try await Participant.query(on: req.db)
            .filter(\.$userID == auth_user.id!)
            .filter(\.$role == "admin")
            .first()
        else {
            throw Abort(.notFound)
        }
        
        try await team.save(on: req.db)
        return team
    }
    
    // MARK: - GET ALL TEAMS OF ROOM (GET Request /teams/roomID route)
    func getAllTeamsOfRoomHandler(req: Request) async throws -> [Team] {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let teams = try await Team.query(on: req.db)
            .filter(\.$roomID == room.id)
            .all()
        return teams
    }
    
    // MARK: - GET USERS OF TEAM (GET Request /teams/users/teamID route)
    func getUsersOfTeamHandler(req: Request) async throws -> [User] {
        guard let team = try await Team.find(req.parameters.get("team_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        let participants = try await Participant.query(on: req.db)
            .filter(\.$teamID == team.id)
            .all()
        var users: [User] = []
        for i in participants {
            var user = try await User.query(on: req.db).filter(\.$id == i.userID).first()
            users.append(user!)
        }
        return users
    }
    
    // MARK: - ADD POINTS TO TEAM (PUT Request /teams/addPoints/teamID route)
    func addPointsHandler(req: Request) async throws -> HTTPStatus {
        guard let team = try await Team.find(req.parameters.get("team_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        struct Context: Content {
            var extra_points: Int
        }
        
        let context = try req.content.decode(Context.self)
        
        team.points = team.points + context.extra_points
        try await team.save(on: req.db)
        return .ok
    }
    
    //MARK: - DELETE ALL TEAMS OF ROOM (DELETE Request /teams/room_id route)
    func deleteTeamsHandler(req: Request) async throws -> HTTPStatus {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let auth_user = try req.auth.require(User.self)
        
        guard let participant = try await Participant.query(on: req.db)
            .filter(\.$userID == auth_user.id!)
            .filter(\.$role == "admin")
            .first()
        else {
            throw Abort(.notFound)
        }
        
        if room.game_status == false {
            let teams = try await Team.query(on: req.db)
                .filter(\.$roomID == room.id)
                .all()
            let participants = try await Participant.query(on: req.db)
                .filter(\.$roomID == room.id!)
                .all()
            participants.forEach { i in
                i.teamID = nil
            }
            try await teams.delete(on: req.db)
        }
        return .ok
    }
}
