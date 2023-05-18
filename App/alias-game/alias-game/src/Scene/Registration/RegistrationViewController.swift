//
//  RegistrationViewController.swift
//  alias-game
//
//  Created by Никита Лисунов on 16.05.2023.
//

import UIKit

protocol RegistrationDisplayLogic: AnyObject {
    typealias Model = RegistrationModel
    func displayStart(_ viewModel: Model.Start.ViewModel)
    func displayAuth(_ viewModel: Model.Auth.ViewModel)
    func displayMainMenu(_ viewModel: Model.MainMenu.ViewModel)
}

final class RegistrationViewController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let fatalError: String = "init(coder:) has not been implemented"
    }
    
    // MARK: - Fields
    private let interactor: RegistrationBusinessLogic
    private let router: RegistrationRoutingLogic
    
    private let mainLabel = UILabel()
    private let signUpLabel = UILabel()
    private let registerButton = UIButton()
    private let loginButton = UIButton()
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    
    // MARK: - LifeCycle
    init(
        router: RegistrationRoutingLogic,
        interactor: RegistrationBusinessLogic
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
        configureSignUpLabel()
        configureRegisterButton()
        configureUsernameTextField()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginButton()
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
    
    private func configureSignUpLabel() {
        self.view.addSubview(signUpLabel)
        signUpLabel.pinTop(
            to: self.view.topAnchor,
            372
        )
        signUpLabel.pinCenter(
            to: self.view.centerXAnchor
        )
        signUpLabel.text = "SignUp"
        signUpLabel.textColor = .black
        signUpLabel.font = .systemFont(
            ofSize: 24,
            weight: .regular
        )
    }
    
    private func configureRegisterButton() {
        self.view.addSubview(registerButton)
        registerButton.pinBottom(
            to: self.view.bottomAnchor,
            84
        )
        registerButton.pinCenter(
            to: self.view.centerXAnchor
        )
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.setTitleColor(.white, for: .highlighted)
        registerButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        registerButton.addTarget(self, action: #selector(registerButtonWasTapped), for: .touchDown)
    }
    
    private func configureLoginButton() {
        self.view.addSubview(loginButton)
        loginButton.pinTop(
            to: passwordTextField.bottomAnchor,
            35
        )
        loginButton.pin(
            to: self.view,
            [.left: 266, .right: 43]
        )
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.setTitleColor(.white, for: .highlighted)
        loginButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        loginButton.addTarget(self, action: #selector(loginButtonWasTapped), for: .touchDown)
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
    
    private func configureEmailTextField() {
        self.view.addSubview(emailTextField)
        emailTextField.placeholder = "E-mail"
        emailTextField.font = .systemFont(
            ofSize: 14,
            weight: .regular
        )
        emailTextField.pinTop(to: usernameTextField.bottomAnchor, 53)
        emailTextField.pin(to: self.view, [.left: 50, .right: 50])
        emailTextField.backgroundColor = .systemYellow
        let paddingView = UIView(frame: CGRect(x: emailTextField.frame.size.width + 10, y: 0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = .always
        emailTextField.layer.shadowColor = UIColor.white.cgColor
        emailTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        emailTextField.layer.shadowOpacity = 1.0
        emailTextField.layer.shadowRadius = 0.0
    }
    
    private func configurePasswordTextField() {
        self.view.addSubview(passwordTextField)
        passwordTextField.placeholder = "Password"
        passwordTextField.font = .systemFont(
            ofSize: 14,
            weight: .regular
        )
        passwordTextField.pinTop(to: emailTextField.bottomAnchor, 53)
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
    private func registerButtonWasTapped() {
        interactor.loadMainMenu(Model.MainMenu.Request(username: usernameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? ""))
    }
    
    @objc
    private func loginButtonWasTapped() {
        interactor.loadAuth(Model.Auth.Request())
    }
}

// MARK: - DisplayLogic
extension RegistrationViewController: RegistrationDisplayLogic {
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
