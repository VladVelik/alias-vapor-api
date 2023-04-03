//
//  CreateRoom.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent

struct CreateRoom: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("rooms")
            .id()
            .field("is_private", .bool, .required)
            .field("invitation_code", .string)
            .field("received_points", .int, .required)
            .field("game_status", .bool, .required)
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("rooms").delete()
    }
}
