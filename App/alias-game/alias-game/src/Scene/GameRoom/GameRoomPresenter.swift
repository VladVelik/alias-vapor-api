//
//  GameRoomPresenter.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomPresentationLogic {
    typealias Model = GameRoomModel
    func presentStart(_ response: Model.Start.Response)
    func presentGameRoomSettings(_ response: Model.Settings.Response)
    func presentBackScreen(_ response: Model.GoBack.Response)
    func presentEditPoints(_ response: Model.CurrentRoomPoints.Response)
    func presentDeletionFromRoom(_ response: Model.DeleteFromRoom.Response)
    func presentChangeTeam(_ response: Model.ChangeTeam.Response)
    func presentStartGame(_ response: Model.StartGame.Response)
    func presentPauseGame(_ response: Model.PauseGame.Response)
    func presentContinueGame(_ response: Model.ContinueGame.Response)
}

final class GameRoomPresenter: GameRoomPresentationLogic {
    private enum Constants { }

    weak var view: GameRoomDisplayLogic?

    func presentStart(_ response: GameRoomModel.Start.Response) {
        view?.displayStart(GameRoomModel.Start.ViewModel(usersWithoutTeam: response.usersWithoutTeam, usersOfTeams: response.usersOfTeams))
    }
    
    func presentGameRoomSettings(_ response: Model.Settings.Response) {
        view?.displayGameRoomSettings(Model.Settings.ViewModel())
    }
    
    func presentBackScreen(_ response: Model.GoBack.Response) {
        view?.displayGoBack(Model.GoBack.ViewModel())
    }
    
    func presentEditPoints(_ response: Model.CurrentRoomPoints.Response) {
        view?.displayEditingPoints(Model.CurrentRoomPoints.ViewModel(current: response.current))
    }
    
    func presentDeletionFromRoom(_ response: Model.DeleteFromRoom.Response) {
        view?.displayDeletionFromRoom(Model.DeleteFromRoom.ViewModel(participant_id: response.participant_id))
    }
    
    func presentChangeTeam(_ response: Model.ChangeTeam.Response) {
        view?.displayChangingTeam(Model.ChangeTeam.ViewModel(user: response.user, teamID: response.teamID))
    }
    
    func presentStartGame(_ response: Model.StartGame.Response) {
        view?.displayStartGame(Model.StartGame.ViewModel(obj: response.obj))
    }
    
    func presentPauseGame(_ response: Model.PauseGame.Response) {
        view?.displayPauseGame(Model.PauseGame.ViewModel())
    }
    
    func presentContinueGame(_ response: Model.ContinueGame.Response) {
        view?.displayContinueGame(Model.ContinueGame.ViewModel())
    }
}
