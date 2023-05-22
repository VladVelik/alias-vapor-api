//
//  GameRoomModel.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

enum GameRoomModel {
    enum Start {
        struct Request { }
        struct Response {
            var usersWithoutTeam: [User]
            var usersOfTeams: [String:[User]]
        }
        struct ViewModel {
            var usersWithoutTeam: [User]
            var usersOfTeams: [String:[User]]
        }
        struct Info { }
    }
    
    enum Settings {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum GoBack {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum CurrentRoomPoints {
        struct Request { }
        struct Response {
            var current: Int
        }
        struct ViewModel {
            var current: Int
        }
        struct Info { }
    }

    enum EditPoints {
        struct Request {
            var points: Int
        }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum ChangeRole {
        struct Request {
            var participant_id: String
            var role: String
        }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum DeleteFromRoom {
        struct Request {
            var participant_id: String
        }
        struct Response {
            var participant_id: String
        }
        struct ViewModel {
            var participant_id: String
        }
        struct Info { }
    }
    
    enum GameStatus {
        struct Request {
            var room_id: String
        }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum ChangeTeam {
        struct Request {
            var teamID: String
        }
        struct Response {
            var teamID: String
            var user: User
        }
        struct ViewModel {
            var user: User
            var teamID: String
        }
        struct Info { }
    }
    
    struct User: Decodable {
        var id: String
        var username: String
        var email: String
        var login_status: Bool
    }

    struct Team {
        var id: String
        var members: [User]
        var points: Int
    }
    
    struct Room: Decodable {
        var id: String?
        var is_private: Bool?
        var invitation_code: String?
        var received_points: Int?
        var game_status: Bool?
    }
}
