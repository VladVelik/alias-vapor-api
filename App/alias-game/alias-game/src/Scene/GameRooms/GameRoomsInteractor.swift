//
//  GameRoomsInteractor.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol GameRoomsBusinessLogic {
    typealias Model = GameRoomsModel
    func loadStart(_ request: Model.Start.Request)
    func loadOpenRooms(_ request: Model.OpenRooms.Request)
    func loadRoom(_ request: Model.RoomI.Request)
}

final class GameRoomsInteractor {
    // MARK: - Fields
    private let presenter: GameRoomsPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: GameRoomsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension GameRoomsInteractor: GameRoomsBusinessLogic {
    func loadOpenRooms(_ request: Model.OpenRooms.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/open") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    let object = try JSONDecoder().decode([Model.Room].self, from: data)
                    DispatchQueue.main.async {
                        self?.presenter.presentOpenRooms(Model.OpenRooms.Response(open_rooms: Model.OpenRoomsList(open_rooms: object)))
                    }
                } catch _ {
                    print("fetch data error")
                }
            }
        }.resume()
    }
    
    func loadRoom(_ request: Model.RoomI.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/enter") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "POST"
        let parameters: [String: Any] = [
            "room_id": request.id,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    User.shared.roomID = request.id
                    User.shared.role = "user"
                    DispatchQueue.main.async {
                        self?.presenter.presentRoom(Model.RoomI.Response())
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
}

