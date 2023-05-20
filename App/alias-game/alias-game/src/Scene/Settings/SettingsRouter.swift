//
//  SettingsRouter.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol SettingsRoutingLogic {
    func routeToMainMenu()
}

final class SettingsRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension SettingsRouter: SettingsRoutingLogic {
    func routeToMainMenu() {
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: true)
    }
}
