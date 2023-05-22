//
//  GameRoomsRouter.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol GameRoomsRoutingLogic {
    func routeToRoom()
    func routeToMainMenu()
}

final class GameRoomsRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension GameRoomsRouter: GameRoomsRoutingLogic {
    func routeToRoom() {
        // Nikt Y
    }
    
    func routeToMainMenu() {
        view?.navigationController?.popViewController(animated: true)
    }
}

