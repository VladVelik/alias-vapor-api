//
//  Room.swift
//  
//
//  Created by Никита Лисунов on 31.03.2023.
//

import Fluent
import Vapor

final class Room: Model, Content {
    static let schema = "rooms"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "is_private")
    var is_private: Bool
    @Field(key: "invitation_code")
    var invitation_code: String?
    @Field(key: "received_points")
    var received_points: Int
    @Field(key: "game_status")
    var game_status: Bool
    
    init() { }
    
    init(id: UUID? = nil, is_private: Bool, invitation_code: String? = nil, received_points: Int, game_status: Bool) {
        self.id = id
        self.is_private = is_private
        self.invitation_code = invitation_code
        self.received_points = received_points
        self.game_status = game_status
    }
}
