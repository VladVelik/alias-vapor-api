//
//  GameRoomAssembly.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

enum GameRoomAssembly {
    static func build() -> UIViewController {
        let router: GameRoomRouter = GameRoomRouter()
        let presenter: GameRoomPresenter = GameRoomPresenter()
        let interactor: GameRoomInteractor = GameRoomInteractor(presenter: presenter)
        let viewController: GameRoomViewController = GameRoomViewController(
            router: router,
            interactor: interactor
        )

        router.view = viewController
        presenter.view = viewController

        return viewController
    }
}
