//
//  Team.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

final class Team: Model, Content {
    static let schema = "teams"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "room_id")
    var roomID: UUID
    @Field(key: "name")
    var name: String
    @Field(key: "points")
    var points: Int
    
    init() { }
    
    init(id: UUID? = nil, roomID: UUID, name: String, points: Int) {
        self.id = id
        self.roomID = roomID
        self.name = name
        self.points = points
    }
}
