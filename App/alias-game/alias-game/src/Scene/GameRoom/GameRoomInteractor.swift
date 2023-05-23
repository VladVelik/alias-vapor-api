//
//  GameRoomInteractor.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomBusinessLogic {
    typealias Model = GameRoomModel
    func loadStart(_ request: Model.Start.Request)
    func loadGameRoomSettings(_ request: Model.Settings.Request)
    func goBack(_ request: Model.GoBack.Request)
    func loadCurrentPointsOfRoom(_ request: Model.CurrentRoomPoints.Request)
    func editPointsOfRoom(_ request: Model.EditPoints.Request)
    func changeRole(_ request: Model.ChangeRole.Request)
    func deleteFromRoom(_ request: Model.DeleteFromRoom.Request)
    func startGame(_ request: Model.GameStatus.Request)
    func pauseGame(_ request: Model.GameStatus.Request)
    func contineGame(_ request: Model.GameStatus.Request)
    func changeTeam(_ request: Model.ChangeTeam.Request)
}

final class GameRoomInteractor: GameRoomBusinessLogic {
    private let presenter: GameRoomPresentationLogic
    
    init(presenter: GameRoomPresentationLogic) {
        self.presenter = presenter
    }
    
    func loadStart(_ request: GameRoomModel.Start.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/allUsersOfEachTeam/\(User.shared.roomID)") else {
            return
        }
        
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let groupedUsers = try decoder.decode([String:[Model.User]].self, from: data)
                    
                    var usersWithoutTeam: [Model.User] = []
                    var usersOfTeams: [String: [Model.User]] = [:]
                    
                    for (key, value) in groupedUsers {
                        if key.isEmpty {
                            usersWithoutTeam = value
                        } else {
                            usersOfTeams[key] = value
                        }
                    }
                    DispatchQueue.main.async {
                        self.presenter.presentStart(Model.Start.Response(usersWithoutTeam: usersWithoutTeam, usersOfTeams: usersOfTeams))
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else {
                print("fetch data error or no room was found")
            }
        }
        task.resume()
    }
    
    func loadGameRoomSettings(_ request: Model.Settings.Request) {
        presenter.presentGameRoomSettings(Model.Settings.Response())
    }
    
    func goBack(_ request: Model.GoBack.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        guard let url = URL(string: "http://127.0.0.1:8080/participants/fromRoomSelf/\(User.shared.id)") else {
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
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self?.presenter.presentBackScreen(Model.GoBack.Response())
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func loadCurrentPointsOfRoom(_ request: Model.CurrentRoomPoints.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/points/\(User.shared.roomID)") else {
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
                    let currentPoints = try JSONDecoder().decode(Int.self, from: data)
                    DispatchQueue.main.async {
                        self?.presenter.presentEditPoints(Model.CurrentRoomPoints.Response(current: currentPoints))
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func editPointsOfRoom(_ request: Model.EditPoints.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/points/\(User.shared.roomID)") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        let parameters: [String: Any] = [
            "points": request.points
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
                    print("New room points!")
                    // TODO: Обновить на экране, если будем отображать поинты в принципе
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func changeRole(_ request: Model.ChangeRole.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/participants/role") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        
        let parameters: [String: Any] = [
            "participant_id": request.participant_id,
            "role": request.role
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    // TODO: Обновить на экране, если будем отображать админов в принципе
                    print("New admin!")
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func deleteFromRoom(_ request: Model.DeleteFromRoom.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/participants/fromRoom/\(request.participant_id)") else {
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
            if let data = data {
                do {
                    DispatchQueue.main.async {
                        self?.presenter.presentDeletionFromRoom(Model.DeleteFromRoom.Response(participant_id: request.participant_id))
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func startGame(_ request: Model.GameStatus.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/startGame/\(request.room_id)") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    // TODO: Добавить функционал
                    print("Игра запущена")
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func pauseGame(_ request: Model.GameStatus.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/pauseGame/\(request.room_id)") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    // TODO: Добавить функционал
                    print("Игра поставлена на паузу")
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func contineGame(_ request: Model.GameStatus.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/rooms/resumeGame/\(request.room_id)") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    // TODO: Добавить функционал
                    print("Игра возобновлена")
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
    
    func changeTeam(_ request: Model.ChangeTeam.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "http://127.0.0.1:8080/teams/enter") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "PUT"
        
        let parameters: [String: Any] = [
            "teamID": request.teamID
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    let user = Model.User(id: User.shared.id, username: User.shared.username, email: "", login_status: true)
                    DispatchQueue.main.async {
                        self?.presenter.presentChangeTeam(Model.ChangeTeam.Response(teamID: request.teamID, user: user))
                    }
                } catch _ {
                    print("fetch data error or no room was found")
                }
            }
        }.resume()
    }
}
