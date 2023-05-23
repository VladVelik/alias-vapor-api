//
//  GameRoomViewController.swift
//  alias-game
//
//  Created by Nik Y on 20.05.2023.
//

import UIKit

protocol GameRoomDisplayLogic: AnyObject {
    typealias Model = GameRoomModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayGameRoomSettings(_ viewModel: Model.Settings.ViewModel)
    func displayGoBack(_ viewModel: Model.GoBack.ViewModel)
    func displayEditingPoints(_ viewModel: Model.CurrentRoomPoints.ViewModel)
    func displayDeletionFromRoom(_ viewModel: Model.DeleteFromRoom.ViewModel)
    func displayChangingTeam(_ viewModel: Model.ChangeTeam.ViewModel)
}

final class GameRoomViewController: UIViewController {
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    private let router: GameRoomRoutingLogic
    private let interactor: GameRoomBusinessLogic
    
    var participants: [Model.User] = []
    var teams: [Model.Team] = []
    var tableView: UITableView!
    var startButton: UIButton!
    var pauseButton: UIButton!
    var continueButton: UIButton!
    var pointsButton: UIButton!
    
    init(router: GameRoomRoutingLogic, interactor: GameRoomBusinessLogic) {
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
        self.title = "Game Room"
        
        self.navigationController?.isNavigationBarHidden = false
        setupNavigationBar()
        if User.shared.role == "admin" {
            setupGameControlButtons()
        }
        setupTableView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableViewTap))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsTapped))
    }
    
    func setupGameControlButtons() {
        
        startButton = UIButton(type: .system)
        startButton.setTitle("Start", for: .normal)
        
        pauseButton = UIButton(type: .system)
        pauseButton.setTitle("Pause", for: .normal)
        
        continueButton = UIButton(type: .system)
        continueButton.setTitle("Continue", for: .normal)
        
        pointsButton = UIButton(type: .system)
        pointsButton.setTitle("Edit Points", for: .normal)
        pointsButton.addTarget(self, action: #selector(editPointsTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [startButton, pauseButton, continueButton, pointsButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        if User.shared.role == "admin" {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10)])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
        }
        
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showEditRoomPoints(_ current: Int) {
        let alertController = UIAlertController(title: "Edit Points", message: "Now it is \(current).", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Points"
            textField.keyboardType = .numberPad
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { (_) in
            if let textField = alertController.textFields?.first, let text = textField.text, let points = Int(text) {
                self.interactor.editPointsOfRoom(Model.EditPoints.Request(points: points))
            }
        })
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    @objc
    private func backTapped() {
        interactor.goBack(Model.GoBack.Request())
    }
    
    @objc
    private func settingsTapped() {
        interactor.loadGameRoomSettings(Model.Settings.Request())
    }
    
    @objc
    private func startButtonTapped() {
        interactor.startGame(Model.GameStatus.Request(room_id: User.shared.roomID))
    }
    
    @objc
    private func pauseButtonTapped() {
        interactor.pauseGame(Model.GameStatus.Request(room_id: User.shared.roomID))
    }
    
    @objc
    private func continueButtonTapped() {
        interactor.contineGame(Model.GameStatus.Request(room_id: User.shared.roomID))
    }
    
    @objc
    private func handleUpArrowButton(sender: UIButton) {
        if let id = sender.accessibilityIdentifier {
            interactor.changeRole(Model.ChangeRole.Request(participant_id: id, role: "admin"))
        }
    }
    
    @objc
    private func handleCrossButton(sender: UIButton) {
        if let id = sender.accessibilityIdentifier {
            interactor.deleteFromRoom(Model.DeleteFromRoom.Request(participant_id: id))
        }
    }
    
    @objc
    private func editPointsTapped(sender: UIButton) {
        interactor.loadCurrentPointsOfRoom(Model.CurrentRoomPoints.Request())
    }
    
    @objc func handleTableViewTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tableView)
        let path = tableView.indexPathForRow(at: location)
        
        // If there is no cell at the tapped location, handle the tap as a tap in an empty section
        if path == nil {
            // Определяем секцию, в которую тапнул пользователь
            for section in 0..<tableView.numberOfSections {
                let sectionRect = tableView.rect(forSection: section)
                if sectionRect.contains(location) {
                    print("Tap in empty section \(section)")
                    if section < teams.count {
                        let teamID = teams[section].id
                        print("tap on team")
                        interactor.changeTeam(Model.ChangeTeam.Request(teamID: teamID))
                    } else {
                        print("move to Unassigned")
                    }
                    break
                }
            }
        }
    }
}

// MARK: - TableView
extension GameRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return teams.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section < teams.count ? teams[section].members.count : participants.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < teams.count ? "Team \(section+1)" : "Unassigned"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = indexPath.section < teams.count ? teams[indexPath.section].members[indexPath.row] : participants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        cell.name = user.username
        cell.upArrowButton.accessibilityIdentifier = user.id
        cell.crossButton.accessibilityIdentifier = user.id
        cell.upArrowButton.addTarget(self, action: #selector(handleUpArrowButton), for: .touchUpInside)
        cell.crossButton.addTarget(self, action: #selector(handleCrossButton), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < teams.count {
            let teamID = teams[indexPath.section].id
            print("tap on team")
            interactor.changeTeam(Model.ChangeTeam.Request(teamID: teamID))
        } else {
            print("move to Unassigned")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGray5
        
        let label = UILabel()
        label.text = self.tableView(tableView, titleForHeaderInSection: section)
        label.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}

class PlayerCell: UITableViewCell {
    var name: String = "" {
        didSet {
            textLabel?.text = name
            if User.shared.username != name {
                addButtons()
            } else {
                textLabel?.textColor = .blue
            }
        }
    }
    
    let upArrowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "arrow.up.square"), for: .normal)
        button.tintColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        return button
    }()
    
    let crossButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark.square"), for: .normal)
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        return button
    }()
    
    private func addButtons() {
        if User.shared.role == "admin" {
            let buttonStack = UIStackView(arrangedSubviews: [upArrowButton, crossButton])
            buttonStack.axis = .horizontal
            buttonStack.spacing = 10
            buttonStack.distribution = .fillEqually
            buttonStack.translatesAutoresizingMaskIntoConstraints = false
            
            self.contentView.addSubview(buttonStack)
            
            NSLayoutConstraint.activate([
                buttonStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15),
                buttonStack.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                buttonStack.widthAnchor.constraint(equalToConstant: 88),
                buttonStack.heightAnchor.constraint(equalToConstant: 44)
            ])
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DisplayLogic
extension GameRoomViewController: GameRoomDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        let currentUserID = User.shared.id
        var isInRoom = false
        
        participants = viewModel.usersWithoutTeam
        for participant in participants {
            if participant.id == currentUserID {
                isInRoom = true
                break
            }
        }
        
        for (teamID, users) in viewModel.usersOfTeams {
            teams.append(Model.Team(id: teamID, members: users, points: 0))
            if !isInRoom {
                for user in users {
                    if user.id == currentUserID {
                        isInRoom = true
//                        User.shared.role = user.key
                        break
                    }
                }
            }
        }
        
        teams.sort { $0.id < $1.id }
        
        if isInRoom {
            self.configureUI()
        } else {
            router.goBack()
        }
    }
    
    func displayGameRoomSettings(_ viewModel: Model.Settings.ViewModel) {
        router.routeToSettings()
    }
    
    func displayGoBack(_ viewModel: Model.GoBack.ViewModel) {
        router.goBack()
    }
    
    func displayEditingPoints(_ viewModel: Model.CurrentRoomPoints.ViewModel) {
        self.showEditRoomPoints(viewModel.current)
    }
    
    func displayDeletionFromRoom(_ viewModel: Model.DeleteFromRoom.ViewModel) {
        let id = viewModel.participant_id
        
//        for i in participants {
//            if i.value.id == id {
//                participants.removeValue(forKey: i.key)
//            }
//        }
        participants.removeAll(where: { $0.id == id })
        
        teams.indices.forEach { index in
//            for i in teams[index].members {
//                if i.value.id == id {
//                    participants.removeValue(forKey: i.key)
//                }
//            }
            teams[index].members.removeAll(where: { $0.id == id })
        }
        
        tableView.reloadData()
    }
    
    func displayChangingTeam(_ viewModel: Model.ChangeTeam.ViewModel) {
        let id = viewModel.user.id
        
//        for i in participants {
//            if i.value.id == id {
//                participants.removeValue(forKey: i.key)
//            }
//        }
        
        participants.removeAll(where: { $0.id == id })
        
        teams.indices.forEach { index in
//            for i in teams[index].members {
//                if i.value.id == id {
//                    participants.removeValue(forKey: i.key)
//                }
//            }
            teams[index].members.removeAll(where: { $0.id == id })
        }
        
        let user = viewModel.user
        let teamID = viewModel.teamID
        
        if let teamIndex = teams.firstIndex(where: { $0.id == teamID }) {
            teams[teamIndex].members.append(user)
        }
        
        tableView.reloadData()
    }
}
