//
//  RegistrationPresenter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol RegistrationPresentationLogic {
    typealias Model = RegistrationModel
    func presentStart(_ response: Model.Start.Response)
    func presentAuth(_ response: Model.Auth.Response)
    func presentMainMenu(_ response: Model.MainMenu.Response)
}

final class RegistrationPresenter {
    // MARK: - Fields
    weak var view: RegistrationDisplayLogic?
}

// MARK: - PresentationLogic
extension RegistrationPresenter: RegistrationPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentAuth(_ response: Model.Auth.Response) {
        view?.displayAuth(Model.Auth.ViewModel())
    }
    
    func presentMainMenu(_ response: Model.MainMenu.Response) {
        view?.displayMainMenu(Model.MainMenu.ViewModel())
    }
}
