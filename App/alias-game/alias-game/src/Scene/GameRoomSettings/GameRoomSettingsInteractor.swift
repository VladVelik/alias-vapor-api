//
//  GameRoomSettingsInteractor.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomSettingsBusinessLogic {
    typealias Model = GameRoomSettingsModel
    func loadStart(_ request: Model.Start.Request)
    func pushGameRoom(_ request: Model.PushGameRoom.Request)
    func deleteGameRoom(_ request: Model.DeleteGameRoom.Request)
}

final class GameRoomSettingsInteractor: GameRoomSettingsBusinessLogic {
    private let presenter: GameRoomSettingsPresentationLogic
    
    init(presenter: GameRoomSettingsPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadStart(_ request: GameRoomSettingsModel.Start.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/settings/\(User.shared.roomID)") else {
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
                    let res = try JSONDecoder().decode([String:Int].self, from: data)
                    var invCode: String = ""
                    var teamCount: Int = 0
                    for (code, count) in res {
                        invCode = code
                        teamCount = count
                    }
                    DispatchQueue.main.async {
                        self?.presenter.presentStart(Model.Start.Response(teamCount: teamCount, invCode: invCode))
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func pushGameRoom(_ request: Model.PushGameRoom.Request) {
        if request.newCount - request.oldCount > 0 {
            let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            guard let url = URL(string: "http://127.0.0.1:8080/teams/fewTeams/\(User.shared.roomID)") else {
                return
            }
            var req = URLRequest(url: url)
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("*/*", forHTTPHeaderField: "Accept")
            req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            req.httpMethod = "POST"
            let parameters: [String: Any] = [
                "countOfTeams": request.newCount-request.oldCount
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            req.httpBody = jsonData
            let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
                if error != nil {
                    return
                }
                if let data = data {
                    do {
                        DispatchQueue.main.async {
                            self?.presenter.presentGameRoom(Model.PushGameRoom.Response())
                        }
                    } catch _ {
                        print("fetch data error or no room was found")
                    }
                }
            }.resume()
        } else if request.newCount - request.oldCount < 0 {
            let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            guard let url = URL(string: "http://127.0.0.1:8080/teams/delete/\(User.shared.roomID)") else {
                return
            }
            var req = URLRequest(url: url)
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.setValue("*/*", forHTTPHeaderField: "Accept")
            req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            req.httpMethod = "DELETE"
            let parameters: [String: Any] = [
                "countOfTeams": request.newCount
            ]
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            req.httpBody = jsonData
            let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
                if error != nil {
                    return
                }
                do {
                    DispatchQueue.main.async {
                        self?.presenter.presentGameRoom(Model.PushGameRoom.Response())
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }.resume()
        } else {
            DispatchQueue.main.async {
                self.presenter.presentGameRoom(Model.PushGameRoom.Response())
            }
        }
    }
    
    func deleteGameRoom(_ request: Model.DeleteGameRoom.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/\(User.shared.roomID)") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "DELETE"
        
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("User account deleted successfully")
                    DispatchQueue.main.async {
                        self?.presenter.presentMainMenu(Model.DeleteGameRoom.Response())
                    }
                } else {
                    print("Error: \(response.statusCode)")
                }
            }
        }.resume()
    }
}

