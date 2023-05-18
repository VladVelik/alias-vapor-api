//
//  LaunchScreenPresenter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol LaunchScreenPresentationLogic {
    typealias Model = LaunchScreenModel
    func presentStart(_ response: Model.Start.Response)
    func presentAuth(_ response: Model.Auth.Response)
}

final class LaunchScreenPresenter {
    // MARK: - Fields
    weak var view: LaunchScreenDisplayLogic?
}

// MARK: - PresentationLogic
extension LaunchScreenPresenter: LaunchScreenPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentAuth(_ response: Model.Auth.Response) {
        view?.displayAuth(Model.Auth.ViewModel())
    }
}
