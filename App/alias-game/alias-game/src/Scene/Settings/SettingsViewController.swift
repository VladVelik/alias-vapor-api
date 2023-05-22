//
//  SettingsViewController.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol SettingsDisplayLogic: AnyObject {
    typealias Model = SettingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayAuth(_ viewModel: Model.Auth.ViewModel)
    func displayMainMenu(_ viewModel: Model.MainMenu.ViewModel)
}

final class SettingsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }

    // MARK: - Fields
    private let router: SettingsRoutingLogic
    private let interactor: SettingsBusinessLogic
    
    private let settingsLabel = UILabel()
    private let toMenuButton = UIButton()
    private let deleteUserButton = UIButton()

    // MARK: - LifeCycle
    init(
        router: SettingsRoutingLogic,
        interactor: SettingsBusinessLogic
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

    // MARK: - Actions
    @objc
    private func toMenuButtonWasTapped() {
        interactor.loadMainMenu(Model.MainMenu.Request())
    }
    
    @objc
    private func deleteUserButtonWasTapped() {
        interactor.loadAuth(Model.Auth.Request(username: User.shared.username, password: User.shared.password))
    }

    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .systemYellow
        self.navigationController?.isNavigationBarHidden = true
        configureMainLabel()
        configureDeleteUserButton()
        configureToMainButton()
    }
    
    private func configureMainLabel() {
        self.view.addSubview(settingsLabel)
        settingsLabel.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 200.0)
        settingsLabel.pinCenter(to: self.view.centerXAnchor)
        settingsLabel.text = "Settings"
        settingsLabel.textColor = .black
        settingsLabel.font = .systemFont(ofSize: 32, weight: .regular)
    }
    
    private func configureToMainButton() {
        self.view.addSubview(toMenuButton)
        toMenuButton.pinBottom(to: self.view.bottomAnchor, 44)
        toMenuButton.pin(to: self.view, [.left: 16, .right: 294])
        let image = UIImage(systemName: "arrowshape.backward.fill", withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30, weight: .regular)))
        toMenuButton.setImage(image, for: .normal)
        toMenuButton.tintColor = .systemGray
        toMenuButton.backgroundColor = .clear
        toMenuButton.addTarget(self, action: #selector(toMenuButtonWasTapped), for: .touchDown)
    }
    
    private func configureDeleteUserButton() {
        self.view.addSubview(deleteUserButton)
        deleteUserButton.pinTop(to: self.view.topAnchor, (self.view.frame.height / 2.0) - 49.0)
        deleteUserButton.pinCenter(to: self.view.centerXAnchor)
        deleteUserButton.setTitle("Delete account", for: .normal)
        deleteUserButton.setTitleColor(.red, for: .normal)
        deleteUserButton.setTitleColor(.white, for: .highlighted)
        deleteUserButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        deleteUserButton.addTarget(self, action: #selector(deleteUserButtonWasTapped), for: .touchDown)
    }
}

extension SettingsViewController: SettingsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayAuth(_ viewModel: Model.Auth.ViewModel) {
        router.routeToAuthorization()
    }
    
    func displayMainMenu(_ viewModel: Model.MainMenu.ViewModel) {
        router.routeToMainMenu()
    }
}
