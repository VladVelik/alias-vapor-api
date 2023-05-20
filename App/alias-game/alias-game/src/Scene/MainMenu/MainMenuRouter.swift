//
//  MainMenuRouter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol MainMenuRoutingLogic {
    func routeToAuthorization()
    func routeToSettings()
    func routeToOpenRooms()
    func routeToPrivateRoom()
    func routeToCreatedRoom()
}

final class MainMenuRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension MainMenuRouter: MainMenuRoutingLogic {
    func routeToAuthorization() {
        view?.navigationController?.pushViewController(AuthorizationAssembly.build(), animated: true)
    }
    
    func routeToSettings() {
        view?.navigationController?.pushViewController(SettingsAssembly.build(), animated: true)
    }
    
    func routeToOpenRooms() {
        // ...
    }
    
    func routeToPrivateRoom() {
        // ...
    }
    
    func routeToCreatedRoom() {
        // ...
    }
}
