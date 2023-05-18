//
//  MainMenuAssembly.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

enum MainMenuAssembly {
    static func build() -> UIViewController {
        let router: MainMenuRouter = MainMenuRouter()
        let presenter: MainMenuPresenter = MainMenuPresenter()
        let interactor: MainMenuInteractor = MainMenuInteractor(presenter: presenter)
        let viewController: MainMenuViewController = MainMenuViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
