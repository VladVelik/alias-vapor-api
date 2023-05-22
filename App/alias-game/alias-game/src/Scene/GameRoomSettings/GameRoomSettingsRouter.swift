//
//  GameRoomSettingsRouter.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomSettingsRoutingLogic {
    func pushGameRoom()
    func pushMainMenu()
}

final class GameRoomSettingsRouter: GameRoomSettingsRoutingLogic {
    weak var view: UIViewController?
    
    func pushGameRoom() {
        view?.navigationController?.pushViewController(GameRoomAssembly.build(), animated: true)
    }
    
    func pushMainMenu() {
        view?.navigationController?.pushViewController(MainMenuAssembly.build(), animated: true)
    }
}
