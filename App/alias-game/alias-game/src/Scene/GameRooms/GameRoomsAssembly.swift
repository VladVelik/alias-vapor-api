//
//  GameRoomsAssembly.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

enum GameRoomsAssembly {
    static func build() -> UIViewController {
        let router: GameRoomsRouter = GameRoomsRouter()
        let presenter: GameRoomsPresenter = GameRoomsPresenter()
        let interactor: GameRoomsInteractor = GameRoomsInteractor(presenter: presenter)
        let viewController: GameRoomsViewController = GameRoomsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
