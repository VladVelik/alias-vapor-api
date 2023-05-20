//
//  SettingsPresenter.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol SettingsPresentationLogic {
    typealias Model = SettingsModel
    func presentStart(_ response: Model.Start.Response)
    func presentMainMenu(_ response: Model.MainMenu.Response)
}

final class SettingsPresenter {
    // MARK: - Fields
    weak var view: SettingsDisplayLogic?
}

// MARK: - PresentationLogic
extension SettingsPresenter: SettingsPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentMainMenu(_ response: Model.MainMenu.Response) {
        view?.displayMainMenu(Model.MainMenu.ViewModel())
    }
}
