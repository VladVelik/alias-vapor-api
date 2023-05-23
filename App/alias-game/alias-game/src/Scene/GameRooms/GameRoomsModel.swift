//
//  GameRoomsModel.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

enum GameRoomsModel {
    enum Start {
        struct Request { }
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum MainMenu {
        struct Request {}
        struct Response { }
        struct ViewModel { }
        struct Info { }
    }
    
    enum RoomI {
        struct Request {
            let id: String
        }
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
    
    struct Room: Decodable {
        var id: String?
        var is_private: Bool?
        var invitation_code: String?
        var received_points: Int?
        var game_status: Bool?
    }
    
    struct OpenRoomsList: Decodable {
        var open_rooms: [Room]?
        
        func getNumberOfRooms() -> Int {
            open_rooms?.count ?? 0
        }
        
        func getID(_ index: Int) -> String {
            guard let rooms = open_rooms else {
                print("No rooms available")
                return "0"
            }

            return rooms[index].id ?? "0"
        }
    }
}
