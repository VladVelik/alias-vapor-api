//
//  RoomsController.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

struct RoomsController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let roomsGroup = routes.grouped("rooms")
        roomsGroup.get(use: getAllHandler)
        roomsGroup.get(":room_id", use: getHandler)
        
        let basicMW = User.authenticator()
        let guardMW = User.guardMiddleware()
        let protected = roomsGroup.grouped(basicMW, guardMW)
        protected.post(use: createHandler)
        protected.put(":room_id", use: updateHandler)
        protected.delete(":room_id", use: deleteHandler)
    }
    
    //MARK: GET Request /rooms route
    func getAllHandler(req: Request) async throws -> [Room] {
        return try await Room.query(on: req.db).all()
    }
    
    //MARK: GET Request /rooms/id= route
    func getHandler(req: Request) async throws -> Room {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return room
    }
    
    //MARK: POST Request /rooms route
    func createHandler(req: Request) async throws -> Room {
        guard let room = try? req.content.decode(Room.self) else {
            throw Abort(.custom(code: 499, reasonPhrase: "Decode Failed"))
        }
        try await room.save(on: req.db)
        return room
    }
    
    //MARK: PUT Request /rooms/id= route
    func updateHandler(req: Request) async throws -> Room {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedRoom = try req.content.decode(Room.self)
        
        room.is_private = updatedRoom.is_private
        room.invitation_code = updatedRoom.invitation_code
        room.received_points = updatedRoom.received_points
        room.game_status = updatedRoom.game_status
        try await room.save(on: req.db)
        return room
    }
    
    //MARK: DELETE Request /rooms/id= route
    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let room = try await Room.find(req.parameters.get("room_id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await room.delete(on: req.db)
        return .ok
    }
}
