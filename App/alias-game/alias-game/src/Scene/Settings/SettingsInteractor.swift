//
//  SettingsInteractor.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol SettingsBusinessLogic {
    typealias Model = SettingsModel
    func loadStart(_ request: Model.Start.Request)
    func loadAuth(_ request: Model.Auth.Request)
    func loadMainMenu(_ request: Model.MainMenu.Request)
}

final class SettingsInteractor {
    // MARK: - Fields
    private let presenter: SettingsPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: SettingsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension SettingsInteractor: SettingsBusinessLogic {
    func loadAuth(_ request: Model.Auth.Request) {
        let loginString = String(format: "%@:%@", User.shared.username, User.shared.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()

        guard let url = URL(string: "http://127.0.0.1:8080/users/\(User.shared.id)") else {
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
                        self?.presenter.presentAuth(Model.Auth.Response())
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
    
    func loadMainMenu(_ request: Model.MainMenu.Request) {
        presenter.presentMainMenu(Model.MainMenu.Response())
    }
}

