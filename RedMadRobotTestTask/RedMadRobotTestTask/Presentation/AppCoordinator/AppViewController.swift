//
//  AppViewController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import UIKit

final class AppViewController: UIViewController {
    
    // MARK: - Private Properties
    
    // --- Services
    
    private let systemStorage: SystemStorage
    private let keychainManager: KeychainManager
    private let authServices: AuthorizationServiceProtocol
    
    private var authToken: AuthTokens?
    
    // --- Childs
    
    lazy private var registrationCoordinator = LoginCoordinator(
        navigationController: UINavigationController(),
        delegate: self
    )
    
    private let appTabBarController = AppTabBarController()
    
    lazy private var lockScreen = LockScreenVC(delegate: self)

    // MARK: - Init
    
    init(
        systemStorage: SystemStorage = UserDefaultsSystemStorage(),
        keychainManager: KeychainManager = KeychainManagerImpl(),
        authService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices
    ) {
        self.systemStorage = systemStorage
        self.keychainManager = keychainManager
        self.authServices = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialController()
    }
    
    // MARK: - Private Methods
    
    private func setInitialController() {
        if (try? keychainManager.getRefreshToken()) != nil && systemStorage.isUserSetPassword {
            addChild(controller: lockScreen, rootView: view)
        } else {
            registrationCoordinator.start()
            addChild(controller: registrationCoordinator.navigationController, rootView: view)
        }
    }
    
    private func showRegistrationFlow() {
        registrationCoordinator.start()
        addChild(controller: registrationCoordinator.navigationController, rootView: view)
    }
    
}

// MARK: - RegistrationFlow Delegate

extension AppViewController: LoginCoordinatorDelegate {
    
    func endRegistrationFlow(token: AuthTokens) {
        self.authToken = token
        changeChildWithAnimation(newChild: lockScreen)
    }

}

// MARK: - LockScreen Delegate

extension AppViewController: LockScreenDelegate {
    
    func showRegistrationModule() {
        registrationCoordinator.start()
        changeChildWithAnimation(newChild: registrationCoordinator.navigationController)
    }
    
    func showAppModule() {
        if authToken != nil {
            guard let tokenData = authToken?.refreshToken.data(using: .utf8) else { return }
            try? keychainManager.saveRefreshToken(tokenData: tokenData)
            ServiceLayer.shared.tokenManager.accessToken = authToken?.accessToken
            self.changeChildWithAnimation(newChild: self.appTabBarController)
        } else {
            _ = authServices.refreshToken { [weak self] _ in
                guard let self = self else { return }
                self.changeChildWithAnimation(newChild: self.appTabBarController)
            }
        }
        
    }
    
}
