//
//  RegistrationRouter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol RegistrationRoutingLogic {
    func routeToAuthorization()
    func routeToMainMenu()
}

final class RegistrationRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension RegistrationRouter: RegistrationRoutingLogic {
    func routeToAuthorization() {
        view?.navigationController?.pushViewController(AuthorizationAssembly.build(), animated: true)
    }
    
    func routeToMainMenu() {
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: true)
    }
}
