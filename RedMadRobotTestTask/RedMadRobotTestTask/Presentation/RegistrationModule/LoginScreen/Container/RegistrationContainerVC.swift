//
//  RegistrationContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 13.05.2021.
//

import UIKit

/// Delegate на который подписан AppViewController
protocol RegistrationContainerVCDelegate: AnyObject {
    
    /// После выполнения flow регистрации, AppViewController решает какой экран показывать следующим
    func endRegistrationFlow()
}

/// Основной контейнер flow для регистрации пользователя, именно этот контроллер делает сетевые запросы и совершает управление координатором для навигации между экранами
final class RegistrationContainerVC: UIViewController {
        
    // MARK: - Private Properties
    
    weak private var delegate: RegistrationContainerVCDelegate?
    
    private let coordinator = RegistrationCoordinator(navigationController: AppNavigationController())
    
    private let userService: UserInfoService
    private let registrationService: AuthorizationService
    
    private var keychainManager: KeychainManager
    private var dataInRamManager: DataInRamManager
    private var authToken: AuthTokens?
    
    // MARK: - Init
    
    init(
        delegate: RegistrationContainerVCDelegate?,
        userService: UserInfoService = ServiceLayer.shared.userInfoService,
        registrationService: AuthorizationService = ServiceLayer.shared.authorizationServices,
        dataInRamManager: DataInRamManager = ServiceLayer.shared.dataInRamManager,
        keychainManager: KeychainManager = KeychainManagerImpl()
    ) {
        self.delegate = delegate
        self.keychainManager = keychainManager
        self.userService = userService
        self.registrationService = registrationService
        self.dataInRamManager = dataInRamManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFirstScreen()
    }
    
    // MARK: - Private Methods
    
    private func setFirstScreen() {
        coordinator.pushLoginScreen(delegate: self)
        addChild(controller: coordinator.navigationController, rootView: view)
    }

}

// MARK: - LoginScreen Delegate

extension RegistrationContainerVC: LoginScreenDelegate {
    
    func signInButtonAction() {
        coordinator.pushSignIn(subscriber: self)
    }
    
    func signUpButtonAction() {
        coordinator.pushSignUp(subscriber: self)
    }
    
}

// MARK: - SignIn Delegate

extension RegistrationContainerVC: SignInDelegate {
    
    func signUpButtonActionFromSignIn() {
        coordinator.pushSignUpFromSignIn(subscriber: self)
    }
    
    func loginUser(credentials: Credentials) {
        self.coordinator.presentLoader { [weak self] in
            guard let self = self else { return }
            self.coordinator.dismissController(animated: true)
        }
        _ = registrationService.signIn(
            credentials: credentials
        ) { [weak self] result in
            guard let self = self else { return }
            self.coordinator.dismissController(animated: true) // Dismiss loader
            switch result {
            case .success(let token):
                self.dataInRamManager.accessToken = token.accessToken
                self.coordinator.pushLockScreen(delegate: self, token: token)
            case .failure(let error):
                self.showErrorAlert(with: error)
            }
        }
    }
    
}

// MARK: - SignUp Delegate

extension RegistrationContainerVC: SignUpContainerDelegate {
    func registrateUser(credentials: Credentials) {
        self.coordinator.presentLoader { [weak self] in
            guard let self = self else { return }
            self.coordinator.dismissController(animated: true)
        }
        
        _ = registrationService.signUp(
            credentials: credentials
        ) { [weak self] result in
            guard let self = self else { return }
            self.coordinator.dismissController(animated: true) // Dismiss loader
            switch result {
            case .success(let token):
                self.authToken = token
                self.dataInRamManager.accessToken = token.accessToken
                self.coordinator.pushSecondSignUpScreen()
            case .failure(let error):
                self.showErrorAlert(with: error)
            }
        }
    }
    
    func addUserInfo(_ userInfo: AddUserInformationModel) {
        self.coordinator.presentLoader { [weak self] in
            guard let self = self else { return }
            self.coordinator.dismissController(animated: true)
        }
        _ = userService.updateUserInfo(
            user: userInfo
        ) { [weak self] result in
            guard let self = self else { return }
            self.coordinator.dismissController(animated: true) // Dismiss loader
            switch result {
            case .success:
                guard let token = self.authToken else { return }
                self.coordinator.pushLockScreen(delegate: self, token: token)
            case .failure(let error):
                self.showErrorAlert(with: error)
            }
        }
    }
    
    func signInButtonActionFromSignUp() {
        coordinator.pushSignInFromSignUp(subscriber: self)
    }
    
}

// MARK: - Success Registration

extension RegistrationContainerVC: SuccessLoginScreenDelegate {
    
    func presentFeedAction() {
        delegate?.endRegistrationFlow()
        
        /// Убираем весь стек контроллеров из navigationController-a, так как у пользователе есть возможность выйти из своего аккаунта и пройти регистрацию заново
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.coordinator.popToRoot(animated: true)
            self.coordinator.enableSwipePopUp()
        }
    }
    
}

// MARK: - Lock Screen Delegate

extension RegistrationContainerVC: LockScreenDelegate {
    
    func logoutAction() {
        coordinator.popToRoot(animated: true)
    }
    
    func successAuthentification() {
        coordinator.pushSuccessRegistration(subscriber: self)
    }
    
}
