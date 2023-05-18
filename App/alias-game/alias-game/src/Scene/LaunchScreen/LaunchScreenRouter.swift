//
//  LaunchScreenRouter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol LaunchScreenRoutingLogic {
    func routeToAuthorization()
}

final class LaunchScreenRouter {
    // MARK: - Fields
    weak var view: UIViewController?
}

// MARK: - RoutingLogic
extension LaunchScreenRouter: LaunchScreenRoutingLogic {
    func routeToAuthorization() {
        view?.navigationController?.pushViewController(AuthorizationAssembly.build(), animated: false)
    }
}
