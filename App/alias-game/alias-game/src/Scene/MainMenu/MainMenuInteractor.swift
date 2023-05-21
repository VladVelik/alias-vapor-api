//
//  MainMenuInteractor.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol MainMenuBusinessLogic {
    typealias Model = MainMenuModel
    func loadStart(_ request: Model.Start.Request)
    func loadAuth(_ request: Model.Auth.Request)
    func loadSettings(_ request: Model.Settings.Request)
    func loadOpenRooms(_ request: Model.OpenRooms.Request)
    func loadCreateRoomAlert(_ request: Model.CreateRoomAlert.Request)
    func loadEnterRoomAlert(_ request: Model.EnterRoomAlert.Request)
    func loadPrivateRoom(_ request: Model.PrivateRoom.Request)
    func loadCreatedRoom(_ request: Model.CreatedRoom.Request)
}

final class MainMenuInteractor {
    // MARK: - Fields
    private let presenter: MainMenuPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: MainMenuPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension MainMenuInteractor: MainMenuBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadAuth(_ request: Model.Auth.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/users/auth") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        let parameters: [String: Any] = [
            "login_status": false
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if data != nil {
                DispatchQueue.main.async {
                    self?.presenter.presentAuth(Model.Auth.Response())
                }
            }
        }.resume()
    }
    
    func loadSettings(_ request: Model.Settings.Request) {
        presenter.presentSettings(Model.Settings.Response())
    }
    
    func loadOpenRooms(_ request: Model.OpenRooms.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        presenter.presentOpenRooms(Model.OpenRooms.Response(/**open_rooms: Model.OpenRoomsList(open_rooms: object))*/))
    }
    
    func loadCreateRoomAlert(_ request: Model.CreateRoomAlert.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        presenter.presentCreateRoomAlert(Model.CreateRoomAlert.Response())
    }
    
    func loadEnterRoomAlert(_ request: Model.EnterRoomAlert.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        presenter.presentEnterRoomAlert(Model.EnterRoomAlert.Response())
    }
    
    func loadPrivateRoom(_ request: Model.PrivateRoom.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/inv_code") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "POST"
        let parameters: [String: Any] = [
            "invitation_code": request.invitation_code
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(Model.Room.self, from: data)
                    self?.presenter.presentPrivateRoom(Model.PrivateRoom.Response(room: object))
                    print("\(object)")
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }

    func loadCreatedRoom(_ request: Model.CreatedRoom.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/create") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "POST"
        let parameters: [String: Any] = [
            "is_private": request.is_private,
            "invitation_code": request.invitation_code,
            "received_points": request.received_points,
            "game_status": false
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(Model.Room.self, from: data)
                    self?.presenter.presentCreatedRoom(Model.CreatedRoom.Response(room: object))
                    print("\(object)")
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
}
