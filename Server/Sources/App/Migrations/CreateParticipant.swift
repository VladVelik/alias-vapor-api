//
//  CreateParticipant.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent

struct CreateParticipant: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("participants")
            .id()
            .field("user_id", .uuid, .required, .references("users", .id))
            .field("room_id", .uuid, .required, .references("rooms", .id))
            .field("team_id", .uuid, .references("teams", .id))
            .field("role", .string, .required)
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("participants").delete()
    }
}
