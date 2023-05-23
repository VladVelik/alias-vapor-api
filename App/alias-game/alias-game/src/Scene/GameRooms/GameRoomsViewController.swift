//
//  GameRoomsViewController.swift
//  alias-game
//
//  Created by Sosin Vladislav on 20.05.2023.
//

import UIKit

protocol GameRoomsDisplayLogic: AnyObject {
    typealias Model = GameRoomsModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayOpenRooms(_ viewModel: Model.OpenRooms.ViewModel)
    func displayRoom(_ viewModel: Model.RoomI.ViewModel)
}

final class GameRoomsViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }

    // MARK: - Fields
    private let router: GameRoomsRoutingLogic
    private let interactor: GameRoomsBusinessLogic
    
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 1200
        return scrollView
    }()
    
    // MARK: - LifeCycle
    init(
        router: GameRoomsRoutingLogic,
        interactor: GameRoomsBusinessLogic
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadOpenRooms(Model.OpenRooms.Request())
    }

    // MARK: - Actions
    @objc
    private func buttonWasTapped(_ sender: UIButton) {
        if let id = sender.accessibilityIdentifier {
            interactor.loadRoom(Model.RoomI.Request(id: id))
        }
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = .systemYellow
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Opened Rooms"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)
        ]
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.pin(to: self.view, [.right: 0, .left: 0, .top: 0, .bottom: 0])
    }
    
    private func configureOpenRooms(_ viewModel: Model.OpenRooms.ViewModel) {
        let openRoomsList = viewModel.open_rooms
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        if openRoomsList.getNumberOfRooms() == 0 {
            return
        }
        
        for i in 0..<openRoomsList.getNumberOfRooms() {
            let button = UIButton()
            button.setTitle("Комната \(openRoomsList.getID(i).prefix(4))", for: .normal)
            button.backgroundColor = .systemBlue
            button.layer.cornerRadius = 10
            button.setTitleColor(.white, for: .normal)
            button.accessibilityIdentifier = openRoomsList.getID(i)
            button.addTarget(self, action: #selector(self.buttonWasTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        stackView.pinTop(to: self.scrollView.topAnchor, 20)
        stackView.pin(to: self.view, [.right: 20, .left: 20])
    }
}

extension GameRoomsViewController: GameRoomsDisplayLogic {
    func displayOpenRooms(_ viewModel: Model.OpenRooms.ViewModel) {
        self.configureOpenRooms(viewModel)
    }
    
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayRoom(_ viewModel: Model.RoomI.ViewModel) {
        router.routeToRoom()
    }
}
