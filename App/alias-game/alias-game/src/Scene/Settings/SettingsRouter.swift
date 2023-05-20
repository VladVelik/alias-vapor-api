//
//  SettingsRouter.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol SettingsRoutingLogic {
    func routeToAuthorization()
    func routeToMainMenu()
}

final class SettingsRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension SettingsRouter: SettingsRoutingLogic {
    func routeToAuthorization() {
        view?.navigationController?.modalPresentationStyle = .fullScreen
        view?.navigationController?.pushViewController(AuthorizationAssembly.build(), animated: true)
    }
    
    func routeToMainMenu() {
        view?.navigationController?.popViewController(animated: true)
        //view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: true)
    }
}
