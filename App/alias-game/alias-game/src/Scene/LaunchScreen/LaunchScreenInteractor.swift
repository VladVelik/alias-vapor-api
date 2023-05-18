//
//  LaunchScreenInteractor.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol LaunchScreenBusinessLogic {
    typealias Model = LaunchScreenModel
    func loadStart(_ request: Model.Start.Request)
    func loadAuth(_ request: Model.Auth.Request)
}

final class LaunchScreenInteractor {
    // MARK: - Fields
    private let presenter: LaunchScreenPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: LaunchScreenPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension LaunchScreenInteractor: LaunchScreenBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadAuth(_ request: Model.Auth.Request) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.presenter.presentAuth(Model.Auth.Response())
        }
    }
}
