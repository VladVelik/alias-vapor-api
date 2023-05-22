//
//  GameRoomRouter.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomRoutingLogic {
    func routeToSettings()
    func goBack()
}

final class GameRoomRouter: GameRoomRoutingLogic {
    weak var view: UIViewController?
    
    func routeToSettings() {
        view?.navigationController?.pushViewController(GameRoomSettingsAssembly.build(), animated: true)
    }
    
    func goBack() {
        view?.navigationController?.popViewController(animated: true)
    }
}
