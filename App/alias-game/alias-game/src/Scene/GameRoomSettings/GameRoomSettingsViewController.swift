//
//  GameRoomSettingsViewController.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomSettingsDisplayLogic: AnyObject {
    typealias Model = GameRoomSettingsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayGameRoom(_ viewModel: Model.PushGameRoom.ViewModel)
    func displayMainMenu(_ viewModel: Model.DeleteGameRoom.ViewModel)
}

final class GameRoomSettingsViewController: UIViewController {
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    private let router: GameRoomSettingsRoutingLogic
    private let interactor: GameRoomSettingsBusinessLogic
    
    // UI Elements
    let teamCountLabel = UILabel()
    let teamCountStepper = UIStepper()
    let codeLabel = UILabel()
    let copyButton = UIButton()
    let deleteButton = UIButton()
    
    var oldTeamCount: Int = 2
    var teamCount: Int = 2 {
        didSet {
            updateCodeLabel()
        }
    }
    
    init(router: GameRoomSettingsRoutingLogic, interactor: GameRoomSettingsBusinessLogic) {
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
        view.backgroundColor = .white
        self.title = "Game Room Settings"
        
        setupNavigationBar()
        setupUI()
        setupActions()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
    }
    
    private func setupUI() {
        // Configure team count label
        teamCountLabel.text = "Number of Teams"
        teamCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(teamCountLabel)
        
        // Configure team count stepper
        teamCountStepper.minimumValue = 2
        teamCountStepper.maximumValue = 10
        teamCountStepper.value = 2
        teamCountStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(teamCountStepper)
        
        // Configure code label
        codeLabel.text = "Sample Code"
        codeLabel.isUserInteractionEnabled = true
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(codeLabel)
        
        // Configure copy button
        copyButton.setTitle("Copy", for: .normal)
        copyButton.setTitleColor(.systemBlue, for: .normal)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(copyButton)
        
        // Configure delete button
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            teamCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            teamCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            teamCountStepper.centerYAnchor.constraint(equalTo: teamCountLabel.centerYAnchor),
            teamCountStepper.leadingAnchor.constraint(equalTo: teamCountLabel.trailingAnchor, constant: 20),
            
            codeLabel.topAnchor.constraint(equalTo: teamCountLabel.bottomAnchor, constant: 20),
            codeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            copyButton.centerYAnchor.constraint(equalTo: codeLabel.centerYAnchor),
            copyButton.leadingAnchor.constraint(equalTo: codeLabel.trailingAnchor, constant: 20),
            
            deleteButton.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        updateCodeLabel()
    }
    
    private func setupActions() {
        teamCountStepper.addTarget(self, action: #selector(teamCountStepperValueChanged(_:)), for: .valueChanged)
        codeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyCodeToClipboard)))
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func updateCodeLabel() {
        teamCountLabel.text = "Количество команд: \(teamCount)"
    }
    
    @objc
    private func teamCountStepperValueChanged(_ stepper: UIStepper) {
        teamCount = Int(stepper.value)
    }
    
    @objc
    private func copyCodeToClipboard() {
        UIPasteboard.general.string = codeLabel.text
    }
    
    @objc
    private func deleteButtonTapped() {
        interactor.deleteGameRoom(Model.DeleteGameRoom.Request())
    }
    
    @objc
    private func backTapped() {
        interactor.pushGameRoom(Model.PushGameRoom.Request(newCount: teamCount, oldCount: oldTeamCount))
    }
}

// MARK: - DisplayLogic
extension GameRoomSettingsViewController: GameRoomSettingsDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        oldTeamCount = viewModel.teamCount
        teamCount = min(viewModel.teamCount, 2)
        codeLabel.text = viewModel.invCode
        if viewModel.invCode.isEmpty {
            codeLabel.text = "У данной комнаты нет кода"
            copyButton.isHidden = true
        }
        self.configureUI()
    }
    
    func displayGameRoom(_ viewModel: Model.PushGameRoom.ViewModel) {
        router.pushGameRoom()
    }
    
    func displayMainMenu(_ viewModel: Model.DeleteGameRoom.ViewModel) {
        router.pushMainMenu()
    }
}

