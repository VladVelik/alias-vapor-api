//
//  RoomsController.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

struct GamePair: Decodable, Encodable, Content {
    var words: [String]
    var team_1: Team
    var team_2: Team
}

struct RoomsController: RouteCollection {
    
    let words = ["apple", "pineapple", "orange", "pear", "pants", "phone", "garden"]
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        let roomsGroup = routes.grouped("rooms")
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = roomsGroup.grouped(basicMW, guardMW)
        
        protected.post("enter", use: enterRoomHandler)
        protected.post("inv_code", use: enterRoomViaInvCodeHandler)
        protected.post("create", use: createRoomHandler)
        protected.put("startGame", ":room_id", use: startGameHandler)
        protected.put("pauseGame", ":room_id", use: pauseGameHandler)
        protected.put("resumeGame", ":room_id", use: resumeGameHandler)
        protected.put("points", ":room_id", use: changePointsHandler)
        protected.delete(":room_id", use: deleteRoomHandler)
        protected.get("open", use: getOpenRoomsHandler)
        protected.get("noTeamUsers", ":room_id", use: getAllUsersWithoutTeam)
        protected.get("allUsersOfEachTeam", ":room_id", use: getAllUsersOfAllTeams)
        protected.get("points", ":room_id", use: getPointsOfRoom)
        protected.get("settings", ":room_id", use: getInvCodeAndCountOfTeams)
    }
    
    // MARK: - ENTER ROOM (POST Request /rooms/enter route)
    func enterRoomHandler(req: Request) async throws -> Participant {
        struct Context: Content {
            var room_id: UUID
        }
        
        let auth_user = try req.auth.require(User.self)
        
        let context = try req.content.decode(Context.self)
        
        let participant = Participant(userID: auth_user.id!, roomID: context.room_id, role: "user")
        
        try await participant.save(on: req.db)
        return participant
    }
    
    // MARK: - ENTER ROOM VIA INVITATION CODE (POST Request /rooms/inv_code route)
    func enterRoomViaInvCodeHandler(req: Request) async throws -> Room {
        struct Context: Content {
            var invitation_code: String
        }
        let auth_user = try req.auth.require(User.self)
        let context = try req.content.decode(Context.self)
        
        guard let room = try await Room.query(on: req.db)
            .filter(\.$invitation_code == context.invitation_code)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        let participant = Participant(userID: auth_user.id!, roomID: room.id!, role: "user")
        
        try await participant.save(on: req.db)
        return room
    }
    
    //MARK: - CREATE ROOM (POST Request /rooms/create route)
    func createRoomHandler(req: Request) async throws -> Room {
        let auth_user = try req.auth.require(User.self)
        guard let room = try? req.content.decode(Room.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        try await room.save(on: req.db)
        
        let participant = Participant(userID: auth_user.id!, roomID: room.id!, role: "admin")
        try await participant.save(on: req.db)
        
        return room
    }
    
    // MARK: - START GAME (PUT Request /rooms/startGame/roomID route)
    func startGameHandler(req: Request) async throws -> [GamePair] {
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

        let teams = try await Team.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .all()
        
        if teams.count < 2 {
            throw Abort(.badRequest)
        }
        
        var pairs: [GamePair] = []
        
        for i in 0..<teams.count {
            for j in i+1..<teams.count {
                if teams[i].id != teams[j].id {
                    pairs.append(GamePair(words: self.words.randomSample(count: 4), team_1: teams[i], team_2: teams[j]))
                }
            }
        }
        
        // send data to all users in room
        // send status to all users in room

        room.game_status = true
        try await room.save(on: req.db)
        return pairs
    }
    
    // MARK: - PAUSE GAME (PUT Request /rooms/pauseGame/roomID route)
    func pauseGameHandler(req: Request) async throws -> HTTPStatus {
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
        
        // send status to all users in room
        
        room.game_status = false
        try await room.save(on: req.db)
        return .ok
    }
    
    // MARK: - RESUME GAME (PUT Request /rooms/resumeGame/roomID route)
    func resumeGameHandler(req: Request) async throws -> HTTPStatus {
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
        
        // send status to all users in room
        
        room.game_status = true
        try await room.save(on: req.db)
        return .ok
    }
    
    // MARK: - CHANGE POINTS NUMBER (PUT Request /rooms/points/roomID route)
    func changePointsHandler(req: Request) async throws -> Room {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        struct Context: Content {
            var points: Int
        }
        
        let points = try req.content.decode(Context.self)
        
        let auth_user = try req.auth.require(User.self)
        guard let user = try await User.query(on: req.db)
            .filter(\.$username == auth_user.username)
            .first()
        else {
            throw Abort(.notFound)
        }
        
        room.received_points = points.points
        try await room.save(on: req.db)
        return room
    }
    
    //MARK: DELETE ROOM (DELETE Request /rooms/id route)
    func deleteRoomHandler(req: Request) async throws -> HTTPStatus {
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
        
        let room_participants = try await Participant.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .all()
        
        try await room_participants.delete(on: req.db)
        
//        room_participants.forEach { i in
//            i.delete(on: req.db)
//        }
        
        let teams = try await Team.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .all()
        
        try await teams.delete(on: req.db)
        
        try await room.delete(on: req.db)
        return .ok
    }
    
    // MARK: - GET ALL OPEN ROOMS (GET Request /rooms/open route)
    func getOpenRoomsHandler(req: Request) async throws -> [Room] {
        let open_rooms = try await Room.query(on: req.db)
            .filter(\.$is_private == false)
            .all()
        return open_rooms
    }
    
    // MARK: - GET ALL USERS WITHOUT TEAM (GET Request /rooms/noTeamUsers/roomID route)
    func getAllUsersWithoutTeam(req: Request) async throws -> [User.Public] {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let room_participants = try await Participant.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .filter(\.$teamID == nil)
            .all()
        
        var users: [User.Public] = []
        for i in room_participants {
            var user = try await User.query(on: req.db).filter(\.$id == i.userID).first()
            users.append((user?.converToPublic())!)
        }
        return users
    }
    
    // MARK: - GET ALL USERS OF EACH TEAMS (GET Request /rooms/allUsersOfEachTeam/roomID route)
    func getAllUsersOfAllTeams(req: Request) async throws -> [String: [User.Public]] {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let teams = try await Team.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .all()
        
        var result: [String: [User.Public]] = [:]
        
        for t in teams {
            let participants = try await Participant.query(on: req.db)
                .filter(\.$teamID == t.id)
                .all()
            var users: [User.Public] = []
            for i in participants {
                var user = try await User.query(on: req.db).filter(\.$id == i.userID).first()
                users.append((user?.converToPublic())!)
//                users[i.role] = (user?.converToPublic())!
            }
            if users.isEmpty {
                result[String(t.id!)] = []
            } else {
                result[String(t.id!)] = users
            }
        }
        
        let room_participants = try await Participant.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .filter(\.$teamID == nil)
            .all()
        
        
        var users: [User.Public] = []
        for i in room_participants {
            var user = try await User.query(on: req.db).filter(\.$id == i.userID).first()
            users.append((user?.converToPublic())!)
//            users[i.role] = (user?.converToPublic())!
        }
        
        result[""] = users
        
        return result
    }
    
    // MARK: - GET POINTS OF ROOM (GET Request /rooms/points/roomID route)
    func getPointsOfRoom(req: Request) async throws -> Int {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return room.received_points
    }
    
    // MARK: - GET INV.CODE & COUNT OF TEAMS OF ROOM (GET Request /rooms/settings/roomID route)
    func getInvCodeAndCountOfTeams(req: Request) async throws -> [String: Int] {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let teams = try await Team.query(on: req.db)
            .filter(\.$roomID == room.id!)
            .all()
        
        var result: [String: Int] = [:]
        
        if let code = room.invitation_code {
            result = [code: teams.count]
        } else {
            result = ["": teams.count]
        }
        
        return result
    }
}
