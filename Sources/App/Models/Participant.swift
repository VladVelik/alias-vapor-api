//
//  Participant.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

final class Participant: Model, Content {
    static let schema = "participants"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "user_id")
    var userID: UUID
    @Field(key: "room_id")
    var roomID: UUID
    @Field(key: "team_id")
    var teamID: UUID?
    @Field(key: "role")
    var role: String
    
    init() { }
    
    init(id: UUID? = nil, userID: UUID, roomID: UUID, teamID: UUID? = nil, role: String) {
        self.id = id
        self.userID = userID
        self.roomID = roomID
        self.teamID = teamID
        self.role = role
    }
}
