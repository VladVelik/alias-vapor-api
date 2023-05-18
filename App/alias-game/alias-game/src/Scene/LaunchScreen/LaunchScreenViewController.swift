//
//  LaunchScreenViewController.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol LaunchScreenDisplayLogic: AnyObject {
    typealias Model = LaunchScreenModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayAuth(_ viewModel: Model.Auth.ViewModel)
}

final class LaunchScreenViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: LaunchScreenBusinessLogic
    private let router: LaunchScreenRoutingLogic
    private let mainLabel = UILabel()
    private let extraLabel = UILabel()
    
    // MARK: - LifeCycle
    init(
        router: LaunchScreenRoutingLogic,
        interactor: LaunchScreenBusinessLogic
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
        interactor.loadAuth(Model.Auth.Request())
    }
    
    // MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .systemYellow
        self.navigationController?.isNavigationBarHidden = true
        configureMainLabel()
        configureExtraText()
    }
    
    private func configureMainLabel() {
        self.view.addSubview(mainLabel)
        mainLabel.pinTop(
            to: self.view.topAnchor,
            270
        )
        mainLabel.pinCenter(
            to: self.view.centerXAnchor
        )
        mainLabel.text = "Alias Game"
        mainLabel.textColor = .black
        mainLabel.font = .systemFont(
            ofSize: 32,
            weight: .regular
        )
    }
    
    private func configureExtraText() {
        self.view.addSubview(extraLabel)
        extraLabel.pinBottom(
            to: self.view.bottomAnchor,
            54
        )
        extraLabel.pinCenter(
            to: self.view.centerXAnchor
        )
        extraLabel.text = "Another one..."
        extraLabel.textColor = .black
        extraLabel.font = .systemFont(
            ofSize: 20,
            weight: .regular
        )
    }
}

// MARK: - DisplayLogic
extension LaunchScreenViewController: LaunchScreenDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayAuth(_ viewModel: Model.Auth.ViewModel) {
        router.routeToAuthorization()
    }
}
