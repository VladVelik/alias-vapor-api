//
//  GameRoomSettingsModel.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

enum GameRoomSettingsModel {
    enum Start {
        struct Request { }
        struct Response {
            var teamCount: Int
            var invCode: String
        }
        struct ViewModel {
            var teamCount: Int
            var invCode: String
        }
        struct Info { }
    }
    
    enum PushGameRoom {
        struct Request {
            var newCount: Int
            var oldCount: Int
        }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum DeleteGameRoom {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    struct Team: Decodable {
        var id: String
        var room_id: String
        var name: String
        var points: Int
    }
}
