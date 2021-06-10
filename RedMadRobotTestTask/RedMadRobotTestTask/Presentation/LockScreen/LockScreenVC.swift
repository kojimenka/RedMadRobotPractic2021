//
//  LockScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 30.05.2021.
//

import UIKit

import LocalAuthentication

protocol LockScreenDelegate: AnyObject {
    func logoutAction()
    func successAuthentification()
}

enum LoginScreenState {
    case lockInRegistration(token: AuthTokens)
    case lockInMainApp
}

final class LockScreenVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var enterButton: RegistrationNextButton!
    
    // MARK: - Private Properties

    private let keychainManager: KeychainManager
    private var dataInRamManager: DataInRamManager
    private var currentState: LoginScreenState
    
    weak private var delegate: LockScreenDelegate?
    
    // MARK: - Init
    
    init(
        currentState: LoginScreenState,
        delegate: LockScreenDelegate?,
        dataInRamManager: DataInRamManager = ServiceLayer.shared.dataInRamManager,
        keychainManager: KeychainManager = KeychainManagerImpl()
    ) {
        self.currentState = currentState
        self.delegate = delegate
        self.keychainManager = keychainManager
        self.dataInRamManager = dataInRamManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isBiometryNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupLabel()
    }
    
    // MARK: - IBActions
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        
        guard let password = passwordTextField.text else { return }
        guard let passwordData = password.data(using: .utf8) else { return }

        if keychainManager.isEntryExist(key: .refreshToken) {
            do {
                let _ = try keychainManager.getRefreshToken(passwordData: passwordData)
                dataInRamManager.password = passwordData
                delegate?.successAuthentification()
            } catch {
                let alert = UIAlertController.createAlert(alertText: "Неверный пароль")
                present(alert, animated: true)
            }
        } else {
            
            if case .lockInRegistration(let token) = currentState {
                let tokenData = token.refreshToken.data(using: .utf8)!

                do {
                    try keychainManager.saveRefreshToken(tokenData: tokenData, passwordData: passwordData)
                    dataInRamManager.password = passwordData
                    self.presentBiometryAlert(passwordData: passwordData)
                } catch let error {
                    let alert = UIAlertController.createAlert(alertText: error.localizedDescription)
                    self.present(alert, animated: true)
                }
            }
            
        }
    }
    
    func isBiometryNeeded() {
        guard keychainManager.isEntryExist(key: .password) else { return }
        let laContext = LAContext()
        
        laContext.evaluateAccessControl(
            KeychainManagerImpl.getBioSecAccessControl(),
            operation: .useItem,
            localizedReason: "Использовать Face ID для входа в приложение?") { [weak self] res, error in
            guard let self = self else { return }
            if res {
                do {
                    let password = try self.keychainManager.getPassword(laContext: laContext)
                    self.dataInRamManager.password = password
                    DispatchQueue.main.async {
                        self.delegate?.successAuthentification()
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        self.presentAlertWithError(error)
                    }
                }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.presentAlertWithError(error)
                }
            }
        }
    }
        
    @IBAction private func logoutButton(_ sender: Any) {
        delegate?.logoutAction()
    }
    
    // MARK: - Private Methods
    
    private func presentBiometryAlert(passwordData: Data) {
        if case .lockInRegistration = currentState {
            let alertController = UIAlertController.createAlertWithTwoButtons(
                alertText: "Использовать Face ID для входа в приложение?",
                confirmButtonTitle: "Да",
                cancelButtonTitle: "Нет") { [weak self] isUserConfirm in
                guard let self = self else { return }
                
                if isUserConfirm {
                    do {
                        let _ = try self.keychainManager.savePassword(data: passwordData)
                    } catch let error {
                        DispatchQueue.main.async {
                            self.presentAlertWithError(error)
                        }
                    }
                }
                
                self.delegate?.successAuthentification()
            }
            
            present(alertController, animated: true)
        }
    }
    
    private func presentAlertWithError(_ error: Error) {
        let alert = UIAlertController.createAlert(alertText: error.localizedDescription)
        self.present(alert, animated: true)
    }
    
    private func setupTextField() {
        passwordTextField.becomeFirstResponder()
        enterButton.isButtonEnable = true
    }
    
    private func setupLabel() {
        if !keychainManager.isEntryExist(key: .refreshToken) {
            titleLabel.text = "Установите пароль"
        } else {
            titleLabel.text = "Введите пароль"
        }
    }
    
}
