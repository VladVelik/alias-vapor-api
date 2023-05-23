//
//  GameRoomsPresenter.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol GameRoomsPresentationLogic {
    typealias Model = GameRoomsModel
    func presentStart(_ response: Model.Start.Response)
    func presentOpenRooms(_ response: Model.OpenRooms.Response)
    func presentRoom(_ response: Model.RoomI.Response)
}

final class GameRoomsPresenter {
    // MARK: - Fields
    weak var view: GameRoomsDisplayLogic?
}

// MARK: - PresentationLogic
extension GameRoomsPresenter: GameRoomsPresentationLogic {
    func presentOpenRooms(_ response: Model.OpenRooms.Response) {
        view?.displayOpenRooms(Model.OpenRooms.ViewModel(open_rooms: response.open_rooms))
    }
    
    func presentRoom(_ response: Model.RoomI.Response) {
        view?.displayRoom(Model.RoomI.ViewModel())
    }
    
    func presentStart(_ response: Model.Start.Response) {
        view?.displayStart(Model.Start.ViewModel())
    }
}
