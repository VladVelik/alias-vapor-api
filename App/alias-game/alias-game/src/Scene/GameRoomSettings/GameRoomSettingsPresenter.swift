//
//  GameRoomSettingsPresenter.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomSettingsPresentationLogic {
    typealias Model = GameRoomSettingsModel
    func presentStart(_ response: Model.Start.Response)
    func presentGameRoom(_ response: Model.PushGameRoom.Response)
    func presentMainMenu(_ response: Model.DeleteGameRoom.Response)
    func presentMakePrivate(_ response: Model.MakePrivate.Response)
}

final class GameRoomSettingsPresenter: GameRoomSettingsPresentationLogic {
    private enum Constants { }

    weak var view: GameRoomSettingsDisplayLogic?

    func presentStart(_ response: GameRoomSettingsModel.Start.Response) {
        view?.displayStart(GameRoomSettingsModel.Start.ViewModel(teamCount: response.teamCount, invCode: response.invCode, isPrivate: response.isPrivate))
    }
    
    func presentGameRoom(_ response: Model.PushGameRoom.Response) {
        view?.displayGameRoom(Model.PushGameRoom.ViewModel())
    }
    
    func presentMainMenu(_ response: Model.DeleteGameRoom.Response) {
        view?.displayMainMenu(Model.DeleteGameRoom.ViewModel())
    }
    
    func presentMakePrivate(_ response: Model.MakePrivate.Response) {
        view?.displayPrivate(Model.MakePrivate.ViewModel(invCode: response.invCode))
    }
}

