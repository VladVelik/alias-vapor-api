//
//  RegistrationInteractor.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol RegistrationBusinessLogic {
    typealias Model = RegistrationModel
    func loadStart(_ request: Model.Start.Request)
    func loadAuth(_ request: Model.Auth.Request)
    func loadMainMenu(_ request: Model.MainMenu.Request)
}

final class RegistrationInteractor {
    // MARK: - Fields
    private let presenter: RegistrationPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: RegistrationPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension RegistrationInteractor: RegistrationBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadAuth(_ request: Model.Auth.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        presenter.presentAuth(Model.Auth.Response())
    }
    
    func loadMainMenu(_ request: Model.MainMenu.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let url = URL(string: "http://127.0.0.1:8080/users/register") else {
            return
        }
        var req = URLRequest(url: url)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("*/*", forHTTPHeaderField: "Accept")
        req.httpMethod = "POST"
        let parameters: [String: Any] = [
            "username": request.username,
            "email": request.email,
            "password": request.password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let group = DispatchGroup()
        group.enter()
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if data != nil {
                User.shared.username = request.username
                User.shared.password = request.password
                self?.presenter.presentMainMenu(Model.MainMenu.Response())
            }
            group.leave()
        }.resume()
        group.wait()
    }
}
