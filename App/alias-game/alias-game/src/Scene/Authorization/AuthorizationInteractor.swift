//
//  AuthorizationInteractor.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol AuthorizationBusinessLogic {
    typealias Model = AuthorizationModel
    func loadStart(_ request: Model.Start.Request)
    func loadRegistration(_ request: Model.Registration.Request)
    func loadMainMenu(_ request: Model.MainMenu.Request)
}

final class AuthorizationInteractor {
    // MARK: - Fields
    private let presenter: AuthorizationPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: AuthorizationPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension AuthorizationInteractor: AuthorizationBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadRegistration(_ request: Model.Registration.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        presenter.presentRegistration(Model.Registration.Response())
    }
    
    func loadMainMenu(_ request: Model.MainMenu.Request) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let loginString = String(format: "%@:%@", request.username, request.password)
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
            "login_status": true
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        req.httpBody = jsonData
        let _ = URLSession.shared.dataTask(with: req) { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            if let data = data {
                do {
                    let object = try JSONDecoder().decode(Model.User.self, from: data)
                    User.shared.id = object.id
                    User.shared.username = request.username
                    User.shared.password = request.password
                    DispatchQueue.main.async {
                        self?.presenter.presentMainMenu(Model.MainMenu.Response())
                    }
                } catch {
                    print("fetch data error")
                }
            }
        }.resume()
    }
}
