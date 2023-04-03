//
//  User.swift
//  
//
//  Created by Никита Лисунов on 30.03.2023.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "username")
    var username: String
    @Field(key: "email")
    var email: String
    @Field(key: "password")
    var password: String
    
    final class Public: Content {
        var id: UUID?
        var username: String
        var email: String
        
        init(id: UUID? = nil, username: String, email: String) {
            self.id = id
            self.username = username
            self.email = email
        }
    }
}

extension User {
    func converToPublic() -> User.Public {
        let pub = User.Public(
            id: self.id,
            username: self.username,
            email: self.email
        )
        return pub
    }
}

extension User: ModelAuthenticatable {
    static var usernameKey = \User.$username
    static var passwordHashKey = \User.$password
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
