//
//  LaunchScreenAssembly.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

enum LaunchScreenAssembly {
    static func build() -> UIViewController {
        let router: LaunchScreenRouter = LaunchScreenRouter()
        let presenter: LaunchScreenPresenter = LaunchScreenPresenter()
        let interactor: LaunchScreenInteractor = LaunchScreenInteractor(presenter: presenter)
        let viewController: LaunchScreenViewController = LaunchScreenViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
