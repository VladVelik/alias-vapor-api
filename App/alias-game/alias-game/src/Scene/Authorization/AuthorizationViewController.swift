//
//  AuthorizationViewController.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol AuthorizationDisplayLogic: AnyObject {
    typealias Model = AuthorizationModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayRegistration(_ viewModel: Model.Registration.ViewModel)
    func displayMainMenu(_ viewModel: Model.MainMenu.ViewModel)
}

final class AuthorizationViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: AuthorizationBusinessLogic
    private let router: AuthorizationRoutingLogic
    
    private let mainLabel = UILabel()
    private let loginLabel = UILabel()
    private let enterButton = UIButton()
    private let registrationButton = UIButton()
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    
    // MARK: - LifeCycle
    init(
        router: AuthorizationRoutingLogic,
        interactor: AuthorizationBusinessLogic
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
        configureMainLabel()
        configureLoginLabel()
        configureEnterButton()
        configureUsernameTextField()
        configurePasswordTextField()
        configureRegistrationButton()
    }
    
    private func configureMainLabel() {
        self.view.addSubview(mainLabel)
        mainLabel.pinTop(
            to: self.view.topAnchor,
            147
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
    
    private func configureLoginLabel() {
        self.view.addSubview(loginLabel)
        loginLabel.pinTop(
            to: self.view.topAnchor,
            372
        )
        loginLabel.pinCenter(
            to: self.view.centerXAnchor
        )
        loginLabel.text = "Login"
        loginLabel.textColor = .black
        loginLabel.font = .systemFont(
            ofSize: 24,
            weight: .regular
        )
    }
    
    private func configureEnterButton() {
        self.view.addSubview(enterButton)
        enterButton.pinBottom(
            to: self.view.bottomAnchor,
            84
        )
        enterButton.pinCenter(
            to: self.view.centerXAnchor
        )
        enterButton.setTitle("Enter", for: .normal)
        enterButton.setTitleColor(.black, for: .normal)
        enterButton.setTitleColor(.white, for: .highlighted)
        enterButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        enterButton.addTarget(self, action: #selector(enterButtonWasTapped), for: .touchDown)
    }
    
    private func configureRegistrationButton() {
        self.view.addSubview(registrationButton)
        registrationButton.pinTop(
            to: passwordTextField.bottomAnchor,
            35
        )
        registrationButton.pin(
            to: self.view,
            [.left: 266, .right: 43]
        )
        registrationButton.setTitle("Registration", for: .normal)
        registrationButton.setTitleColor(.black, for: .normal)
        registrationButton.setTitleColor(.white, for: .highlighted)
        registrationButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        registrationButton.addTarget(self, action: #selector(registrationButtonWasTapped), for: .touchDown)
    }
    
    private func configureUsernameTextField() {
        self.view.addSubview(usernameTextField)
        usernameTextField.placeholder = "Username"
        usernameTextField.font = .systemFont(
            ofSize: 14,
            weight: .regular
        )
        usernameTextField.pinTop(to: self.view.topAnchor, 440)
        usernameTextField.pin(to: self.view, [.left: 50, .right: 50])
        usernameTextField.backgroundColor = .systemYellow
        let paddingView = UIView(frame: CGRect(x: usernameTextField.frame.size.width + 10, y: 0, width: usernameTextField.frame.size.width, height: usernameTextField.frame.size.height))
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
        usernameTextField.layer.shadowColor = UIColor.white.cgColor
        usernameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        usernameTextField.layer.shadowOpacity = 1.0
        usernameTextField.layer.shadowRadius = 0.0
    }
    
    private func configurePasswordTextField() {
        self.view.addSubview(passwordTextField)
        passwordTextField.placeholder = "Password"
        passwordTextField.font = .systemFont(
            ofSize: 14,
            weight: .regular
        )
        passwordTextField.pinTop(to: usernameTextField.bottomAnchor, 53)
        passwordTextField.pin(to: self.view, [.left: 50, .right: 50])
        passwordTextField.backgroundColor = .systemYellow
        let paddingView = UIView(frame: CGRect(x: passwordTextField.frame.size.width + 10, y: 0, width: passwordTextField.frame.size.width, height: passwordTextField.frame.size.height))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
        passwordTextField.layer.shadowColor = UIColor.white.cgColor
        passwordTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        passwordTextField.layer.shadowOpacity = 1.0
        passwordTextField.layer.shadowRadius = 0.0
    }
    
    // MARK: - Actions
    @objc
    private func enterButtonWasTapped() {
        interactor.loadMainMenu(Model.MainMenu.Request(username: usernameTextField.text ?? "", password: passwordTextField.text ?? ""))
    }

    @objc
    private func registrationButtonWasTapped() {
        interactor.loadRegistration(Model.Registration.Request())
    }
}

// MARK: - DisplayLogic
extension AuthorizationViewController: AuthorizationDisplayLogic {
    func displayStart(_ viewModel: Model.Start.ViewModel) {
        self.configureUI()
    }
    
    func displayRegistration(_ viewModel: Model.Registration.ViewModel) {
        router.routeToRegistration()
    }
    
    func displayMainMenu(_ viewModel: Model.MainMenu.ViewModel) {
        router.routeToMainMenu()
    }
}

