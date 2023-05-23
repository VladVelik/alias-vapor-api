//
//  GameRoomSettingsAssembly.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

enum GameRoomSettingsAssembly {
    static func build() -> UIViewController {
        let router: GameRoomSettingsRouter = GameRoomSettingsRouter()
        let presenter: GameRoomSettingsPresenter = GameRoomSettingsPresenter()
        let interactor: GameRoomSettingsInteractor = GameRoomSettingsInteractor(presenter: presenter)
        let viewController: GameRoomSettingsViewController = GameRoomSettingsViewController(
            router: router,
            interactor: interactor
        )

        router.view = viewController
        presenter.view = viewController

        return viewController
    }
}
