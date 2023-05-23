//
//  MainMenuPresenter.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol MainMenuPresentationLogic {
    typealias Model = MainMenuModel
    func presentStart(_ response: Model.Start.Response)
    func presentAuth(_ response: Model.Auth.Response)
    func presentSettings(_ response: Model.Settings.Response)
    func presentOpenRooms(_ response: Model.OpenRooms.Response)
    func presentCreateRoomAlert(_ response: Model.CreateRoomAlert.Response)
    func presentEnterRoomAlert(_ response: Model.EnterRoomAlert.Response)
    func presentPrivateRoom(_ response: Model.PrivateRoom.Response)
    func presentCreatedRoom(_ response: Model.CreatedRoom.Response)
}

final class MainMenuPresenter {
    // MARK: - Fields
    weak var view: MainMenuDisplayLogic?
}

// MARK: - PresentationLogic
extension MainMenuPresenter: MainMenuPresentationLogic {
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
    
    func presentAuth(_ response: Model.Auth.Response) {
        view?.displayAuth(Model.Auth.ViewModel())
    }
    
    func presentSettings(_ response: Model.Settings.Response) {
        view?.displaySettings(Model.Settings.ViewModel())
    }
    
    func presentOpenRooms(_ response: Model.OpenRooms.Response) {
        view?.displayOpenRooms(Model.OpenRooms.ViewModel(open_rooms: response.open_rooms))
    }
    
    func presentCreateRoomAlert(_ response: Model.CreateRoomAlert.Response) {
        view?.displayCreateRoomAlert(Model.CreateRoomAlert.ViewModel())
    }
    
    func presentEnterRoomAlert(_ response: Model.EnterRoomAlert.Response) {
        view?.displayEnterRoomAlert(Model.EnterRoomAlert.ViewModel())
    }
    
    func presentPrivateRoom(_ response: Model.PrivateRoom.Response) {
        view?.displayPrivateRoom(Model.PrivateRoom.ViewModel(room: response.room))
    }
    
    func presentCreatedRoom(_ response: Model.CreatedRoom.Response) {
        view?.displayCreatedRoom(Model.CreatedRoom.ViewModel(room: response.room))
    }
}
