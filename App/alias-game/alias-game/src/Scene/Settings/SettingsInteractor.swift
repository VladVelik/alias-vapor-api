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
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let loginString = String(format: "%@:%@", request.username, request.password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        let userId = User.shared.id
        
        let urlString = "http://127.0.0.1:8080/users/\(userId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    print("User account deleted successfully")
                    DispatchQueue.main.async {
                        self.presenter.presentAuth(Model.Auth.Response())
                    }
                } else {
                    print("Error: \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadMainMenu(_ request: Model.MainMenu.Request) {
        presenter.presentMainMenu(Model.MainMenu.Response())
    }
}

