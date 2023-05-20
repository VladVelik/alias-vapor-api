//
//  SettingsInteractor.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol SettingsBusinessLogic {
    typealias Model = SettingsModel
    func loadStart(_ request: Model.Start.Request)
    func loadMainMenu(_ request: Model.MainMenu.Request)
}

final class SettingsInteractor {
    // MARK: - Fields
    private let presenter: SettingsPresentationLogic
    
    // MARK: - LifeCycle
    init(presenter: SettingsPresentationLogic) {
        self.presenter = presenter
    }
}

// MARK: - BusinessLogic
extension SettingsInteractor: SettingsBusinessLogic {
    func loadStart(_ request: Model.Start.Request) {
        presenter.presentStart(Model.Start.Response())
    }
    
    func loadMainMenu(_ request: Model.MainMenu.Request) {
        presenter.presentMainMenu(Model.MainMenu.Response())
    }
}

