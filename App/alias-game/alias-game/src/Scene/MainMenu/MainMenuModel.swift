//
//  MainMenuModel.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

enum MainMenuModel {
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum Auth {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum Settings {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum OpenRooms {
        struct Request { }
        struct Response {
            let open_rooms: OpenRoomsList
        }
        struct ViewModel {
            let open_rooms: OpenRoomsList
        }
        struct Info { }
    }
    
    enum CreateRoomAlert {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum EnterRoomAlert {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum PrivateRoom {
        struct Request {
            let invitation_code: String
        }
        struct Response {
            let room: Room
        }
        struct ViewModel {
            let room: Room
        }
        struct Info { }
    }
    
    enum CreatedRoom {
        struct Request {
            let is_private: Bool
            let invitation_code: String
            let received_points: Int
        }
        struct Response {
            let room: Room
        }
        struct ViewModel {
            let room: Room
        }
        struct Info { }
    }
    
    struct Room: Decodable {
        var id: String?
        var is_private: Bool?
        var invitation_code: String?
        var received_points: Int?
        var game_status: Bool?
    }
    
    struct OpenRoomsList: Decodable {
        var open_rooms: [Room]?
    }
}
