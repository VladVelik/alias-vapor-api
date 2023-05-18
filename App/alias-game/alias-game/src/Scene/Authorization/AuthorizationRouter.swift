//
//  AuthorizationRouter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol AuthorizationRoutingLogic {
    func routeToRegistration()
    func routeToMainMenu()
}

final class AuthorizationRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension AuthorizationRouter: AuthorizationRoutingLogic {
    func routeToRegistration() {
        view?.navigationController?.pushViewController(RegistrationAssembly.build(), animated: true)
    }
    
    func routeToMainMenu() {
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: true)
    }
}
