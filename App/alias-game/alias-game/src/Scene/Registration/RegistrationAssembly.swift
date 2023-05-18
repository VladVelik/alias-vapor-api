//
//  RegistrationAssembly.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

enum RegistrationAssembly {
    static func build() -> UIViewController {
        let router: RegistrationRouter = RegistrationRouter()
        let presenter: RegistrationPresenter = RegistrationPresenter()
        let interactor: RegistrationInteractor = RegistrationInteractor(presenter: presenter)
        let viewController: RegistrationViewController = RegistrationViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
