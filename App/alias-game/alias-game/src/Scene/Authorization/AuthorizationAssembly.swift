//
//  AuthorizationAssembly.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

enum AuthorizationAssembly {
    static func build() -> UIViewController {
        let router: AuthorizationRouter = AuthorizationRouter()
        let presenter: AuthorizationPresenter = AuthorizationPresenter()
        let interactor: AuthorizationInteractor = AuthorizationInteractor(presenter: presenter)
        let viewController: AuthorizationViewController = AuthorizationViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
