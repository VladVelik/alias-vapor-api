//
//  SettingsAssembly.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

enum SettingsAssembly {
    static func build() -> UIViewController {
        let router: SettingsRouter = SettingsRouter()
        let presenter: SettingsPresenter = SettingsPresenter()
        let interactor: SettingsInteractor = SettingsInteractor(presenter: presenter)
        let viewController: SettingsViewController = SettingsViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
