//
//  CreateUser.swift
//  
//
//  Created by Никита Лисунов on 30.03.2023.
//

import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        let schema = database.schema("users")
            .id()
            .field("username", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "username")
            .unique(on: "email")
        try await schema.create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema("users").delete()
    }
}
