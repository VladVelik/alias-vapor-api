//
//  CreateTeam.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent

struct CreateTeam: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("teams")
            .id()
            .field("room_id", .uuid, .required, .references("rooms", .id))
            .field("name", .string, .required)
            .field("points", .int, .required)
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("teams").delete()
    }
}
