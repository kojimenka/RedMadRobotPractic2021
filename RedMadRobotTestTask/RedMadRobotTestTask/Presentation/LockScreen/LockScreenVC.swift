//
//  LockScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 30.05.2021.
//

import UIKit

import LocalAuthentication

protocol LockScreenDelegate: AnyObject {
    func showRegistrationModule()
    func showAppModule()
}

final class LockScreenVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var enterButton: RegistrationNextButton!
    
    // MARK: - Private Properties

    private let keychainManager: KeychainManager
    private var systemStorage: SystemStorage
    
    weak private var delegate: LockScreenDelegate?
    
    // MARK: - Init
    
    init(
        delegate: LockScreenDelegate?,
        keychainManager: KeychainManager = KeychainManagerImpl(),
        systemStorage: SystemStorage = UserDefaultsSystemStorage()
    ) {
        self.delegate = delegate
        self.keychainManager = keychainManager
        self.systemStorage = systemStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentBiometryAlert()
        useBiometry()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupLabel()
    }
    
    // MARK: - IBActions
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        let passwordText = passwordTextField.text
        guard let passwordData = passwordText?.data(using: .utf8) else { return }
        
        if !systemStorage.isUserSetPassword {
            do {
                try keychainManager.savePassword(data: passwordData)
                systemStorage.isUserSetPassword = true
                delegate?.showAppModule()
            } catch let error {
                print(error)
            }
        } else {
            do {
                let realPassword = try keychainManager.getPassword()
                if realPassword == passwordData {
                    self.delegate?.showAppModule()
                } else {
                    let alert = UIAlertController.createAlert(alertText: "Неверный пароль")
                    present(alert, animated: true)
                }
            } catch let error {
                print(error)
            }
        }
    
    }
    
    @IBAction private func logoutButton(_ sender: Any) {
        delegate?.showRegistrationModule()
    }
    
    // MARK: - Private Methods
    
    private func presentBiometryAlert() {
        if !systemStorage.isUserSetPassword {
            let alertController = UIAlertController.createAlertWithTwoButtons(
                alertText: "Использовать биометрию для пароля",
                confirmButtonTitle: "Да",
                cancelButtonTitle: "Нет") { [weak self] isUserConfirm in
                guard let self = self else { return }
                self.systemStorage.isUserAccessBiometry = isUserConfirm
            }
            
            present(alertController, animated: true)
        }
    }
    
    private func useBiometry() {
        if systemStorage.isUserAccessBiometry {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                error: &error
            ) {
                let reason = "Use biometric for easy unlock"
                
                context.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reason
                ) { [weak self] result, _ in
                    guard let self = self else { return }
                    if result {
                        self.delegate?.showAppModule()
                    }
                }
            }
        }
    }
    
    private func setupTextField() {
        passwordTextField.becomeFirstResponder()
        enterButton.isButtonEnable = true
    }
    
    private func setupLabel() {
        if !systemStorage.isUserSetPassword {
            titleLabel.text = "Установите пароль"
        } else {
            titleLabel.text = "Введите пароль"
        }
    }
    
}
