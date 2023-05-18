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
    @Field(key: "login_status")
    var login_status: Bool?
    
    final class Public: Content {
        var id: UUID?
        var username: String
        var email: String
        var login_status: Bool?
        
        init(id: UUID? = nil, username: String, email: String, login_status: Bool? = false) {
            self.id = id
            self.username = username
            self.email = email
            self.login_status = login_status
        }
    }
}

extension User {
    func converToPublic() -> User.Public {
        let pub = User.Public(
            id: self.id,
            username: self.username,
            email: self.email,
            login_status: self.login_status
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
