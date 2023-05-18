//
//  AuthorizationPresenter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol AuthorizationPresentationLogic {
    typealias Model = AuthorizationModel
    func presentStart(_ response: Model.Start.Response)
    func presentRegistration(_ response: Model.Registration.Response)
    func presentMainMenu(_ response: Model.MainMenu.Response)
}

final class AuthorizationPresenter {
    // MARK: - Fields
    weak var view: AuthorizationDisplayLogic?
}

// MARK: - PresentationLogic
extension AuthorizationPresenter: AuthorizationPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentRegistration(_ response: Model.Registration.Response) {
        view?.displayRegistration(Model.Registration.ViewModel())
    }
    
    func presentMainMenu(_ response: Model.MainMenu.Response) {
        view?.displayMainMenu(Model.MainMenu.ViewModel())
    }
}
