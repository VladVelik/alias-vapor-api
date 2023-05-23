//
//  MainMenuViewController.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol MainMenuDisplayLogic: AnyObject {
    typealias Model = MainMenuModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayAuth(_ viewModel: Model.Auth.ViewModel)
    func displaySettings(_ viewModel: Model.Settings.ViewModel)
    func displayOpenRooms(_ viewModel: Model.OpenRooms.ViewModel)
    func displayCreateRoomAlert(_ viewModel: Model.CreateRoomAlert.ViewModel)
    func displayEnterRoomAlert(_ viewModel: Model.EnterRoomAlert.ViewModel)
    func displayPrivateRoom(_ viewModel: Model.PrivateRoom.ViewModel)
    func displayCreatedRoom(_ viewModel: Model.CreatedRoom.ViewModel)
}

final class MainMenuViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: MainMenuBusinessLogic
    private let router: MainMenuRoutingLogic
    
    private let mainMenuLabel = UILabel()
    private let logoutButton = UIButton()
    private let settingsButton = UIButton()
    private let openRoomsButton = UIButton()
    private let enterRoomButton = UIButton()
    private let createRoomButton = UIButton()
    private let enterRoomAlert = UIAlertController(title: "Enter Room", message: "Enter the room via invitation code", preferredStyle: .alert)
    private let createRoomAlert = UIAlertController(title: "Create Room", message: "Create new room", preferredStyle: .alert)
    
    // MARK: - LifeCycle
    init(
        router: MainMenuRoutingLogic,
        interactor: MainMenuBusinessLogic
    ) {
        self.router = router
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.fatalError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadStart(Model.Start.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .systemYellow
        self.navigationController?.isNavigationBarHidden = true
        configureMainMenuLabel()
        configureLogoutButton()
        configureSettingsButton()
        configureCreateRoomButton()
        configureOpenRoomsButton()
        configureEnterRoomButton()
        configureEnterRoomAlert()
        configureCreateRoomAlert()
    }
    
    private func configureMainMenuLabel() {
        self.view.addSubview(mainMenuLabel)
        mainMenuLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 182.0)
        mainMenuLabel.pinCenter(to: self.view.centerXAnchor)
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.textColor = .black
        mainMenuLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureLogoutButton() {
        self.view.addSubview(logoutButton)
        logoutButton.pinBottom(to: self.view.bottomAnchor, 44)
        logoutButton.pin(to: self.view, [.left: 16, .right: 294])
        let image = UIImage(systemName: "door.right.hand.open", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        logoutButton.setImage(image, for: .normal)
        logoutButton.tintColor = .systemGray
        logoutButton.backgroundColor = .clear
        logoutButton.addTarget(self, action: #selector(logoutButtonWasTapped), for: .touchDown)
    }
    
    private func configureSettingsButton() {
        self.view.addSubview(settingsButton)
        settingsButton.pinBottom(to: self.view.bottomAnchor, 42)
        settingsButton.pin(to: self.view, [.right: 16, .left: 294])
        let image = UIImage(systemName: "gear", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        settingsButton.setImage(image, for: .normal)
        settingsButton.tintColor = .systemGray
        settingsButton.backgroundColor = .clear
        settingsButton.addTarget(self, action: #selector(settingsButtonWasTapped), for: .touchDown)
    }
    
    private func configureCreateRoomButton() {
        self.view.addSubview(createRoomButton)
        createRoomButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 49.0)
        createRoomButton.pinCenter(to: self.view.centerXAnchor)
        createRoomButton.setTitle("Create Room", for: .normal)
        createRoomButton.setTitleColor(.black, for: .normal)
        createRoomButton.setTitleColor(.white, for: .highlighted)
        createRoomButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        createRoomButton.addTarget(self, action: #selector(createRoomButtonWasTapped), for: .touchDown)
    }
    
    private func configureOpenRoomsButton() {
        self.view.addSubview(openRoomsButton)
        openRoomsButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 11.0)
        openRoomsButton.pinCenter(to: self.view.centerXAnchor)
        openRoomsButton.setTitle("Open Rooms", for: .normal)
        openRoomsButton.setTitleColor(.black, for: .normal)
        openRoomsButton.setTitleColor(.white, for: .highlighted)
        openRoomsButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        openRoomsButton.addTarget(self, action: #selector(openRoomsButtonWasTapped), for: .touchDown)
    }
    
    private func configureEnterRoomButton() {
        self.view.addSubview(enterRoomButton)
        enterRoomButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) + 71.0)
        enterRoomButton.pinCenter(to: self.view.centerXAnchor)
        enterRoomButton.setTitle("Enter Room", for: .normal)
        enterRoomButton.setTitleColor(.black, for: .normal)
        enterRoomButton.setTitleColor(.white, for: .highlighted)
        enterRoomButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        enterRoomButton.addTarget(self, action: #selector(enterRoomButtonWasTapped), for: .touchDown)
    }
    
    private func configureEnterRoomAlert() {
        let enterButton = UIAlertAction(title: "Enter", style: .default, handler: { [weak enterRoomAlert, weak self] (action) -> Void in
            self?.interactor.loadPrivateRoom(Model.PrivateRoom.Request(invitation_code: enterRoomAlert?.textFields![0].text ?? ""))
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        self.enterRoomAlert.addAction(enterButton)
        enterRoomAlert.addAction(cancelButton)
        enterRoomAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Invitation Code"
        })
    }
    
    private func configureCreateRoomAlert() {
        let createButton = UIAlertAction(title: "Create", style: .default, handler: { [weak createRoomAlert, weak self] (action) -> Void in
            self?.interactor.loadCreatedRoom(Model.CreatedRoom.Request(is_private: createRoomAlert?.textFields![0].text?.boolValue ?? false, invitation_code: createRoomAlert?.textFields![1].text ?? "", received_points: Int(createRoomAlert?.textFields![2].text ?? "0") ?? 0))
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        self.createRoomAlert.addAction(createButton)
        createRoomAlert.addAction(cancelButton)
        createRoomAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Is Private (true / false)"
        })
        createRoomAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Invitation Code (If Private is TRUE)"
        })
        createRoomAlert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Received Points (INT)"
        })
    }
    
    // MARK: - Actions
    @objc
    private func logoutButtonWasTapped() {
        interactor.loadAuth(Model.Auth.Request())
    }
    
    @objc
    private func settingsButtonWasTapped() {
        interactor.loadSettings(Model.Settings.Request())
    }
    
    @objc
    private func openRoomsButtonWasTapped() {
        interactor.loadOpenRooms(Model.OpenRooms.Request())
    }
    
    @objc
    private func enterRoomButtonWasTapped() {
        interactor.loadEnterRoomAlert(Model.EnterRoomAlert.Request())
    }
    
    @objc
    private func createRoomButtonWasTapped() {
        interactor.loadCreateRoomAlert(Model.CreateRoomAlert.Request())
    }
}

// MARK: - DisplayLogic
extension MainMenuViewController: MainMenuDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayAuth(_ viewModel: Model.Auth.ViewModel) {
        router.routeToAuthorization()
    }
    
    func displaySettings(_ viewModel: Model.Settings.ViewModel) {
        router.routeToSettings()
    }
    
    func displayOpenRooms(_ viewModel: Model.OpenRooms.ViewModel) {
        router.routeToOpenRooms()
    }
    
    func displayEnterRoomAlert(_ viewModel: Model.EnterRoomAlert.ViewModel) {
        self.navigationController?.present(self.enterRoomAlert, animated: true)
    }
    
    func displayCreateRoomAlert(_ viewModel: Model.CreateRoomAlert.ViewModel) {
        self.navigationController?.present(self.createRoomAlert, animated: true)
    }
    
    func displayPrivateRoom(_ viewModel: Model.PrivateRoom.ViewModel) {
        router.routeToPrivateRoom()
    }
    
    func displayCreatedRoom(_ viewModel: Model.CreatedRoom.ViewModel) {
        router.routeToCreatedRoom()
    }
}
