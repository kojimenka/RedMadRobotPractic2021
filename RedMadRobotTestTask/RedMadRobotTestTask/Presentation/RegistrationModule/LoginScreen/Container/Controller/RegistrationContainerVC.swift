//
//  RegistrationContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 13.05.2021.
//

import UIKit

final class RegistrationContainerVC: UIViewController {
    
    // MARK: - Private Properties
    
    weak private var coordinator: LoginCoordinator?
    
    private var requestViewModel: RegistrationContainerRequestViewModelProtocol
    
    // MARK: - Init
    
    init(
        requestViewModel: RegistrationContainerRequestViewModelProtocol = RegistrationContainerRequestViewModel(),
        coordinator: LoginCoordinator
    ) {
        self.requestViewModel = requestViewModel
        self.coordinator = coordinator
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
        coordinator?.pushLoginScreen(subscriber: self)
    }

}

// MARK: - LoginScreen Delegate

extension RegistrationContainerVC: LoginScreenDelegate {
    
    func signInButtonAction() {
        coordinator?.pushSignIn(subscriber: self)
    }
    
    func signUpButtonAction() {
        coordinator?.pushSignUp(subscriber: self)
    }
    
}

// MARK: - SignIn Delegate

extension RegistrationContainerVC: SignInDelegate {
    
    func signUpButtonActionFromSignIn() {
        coordinator?.pushSignUpFromSignIn(subscriber: self)
    }
    
    func loginUser(credentials: Credentials) {
        self.coordinator?.presentLoader { [weak self] in
            guard let self = self else { return }
            self.coordinator?.dismissController(animated: true)
        }
        requestViewModel.loginUser(
            credentials: credentials
        ) { [weak self] result in
            guard let self = self else { return }
            self.coordinator?.dismissController(animated: true) // Dismiss loader
            switch result {
            case .success:
                self.coordinator?.pushSuccessRegistration(subscriber: self)
            case .failure(let error):
                self.showErrorAlert(with: error)
            }
        }
    }
    
}

// MARK: - SignUp Delegate

extension RegistrationContainerVC: SignUpContainerDelegate {
    func registrateUser(credentials: Credentials, userInfo: UserInformation) {
        self.coordinator?.presentLoader { [weak self] in
            guard let self = self else { return }
            self.coordinator?.dismissController(animated: true)
        }
        requestViewModel.registrateUser(
            credentials: credentials,
            userInfo: userInfo
        ) { [weak self] result in
            guard let self = self else { return }
            self.coordinator?.dismissController(animated: true) // Dismiss loader
            switch result {
            case .success:
                self.coordinator?.pushSuccessRegistration(subscriber: self)
            case .failure(let error):
                self.showErrorAlert(with: error)
            }
        }
    }
    
    func signInButtonActionFromSignUp() {
        coordinator?.pushSignInFromSignUp(subscriber: self)
    }
    
}

// MARK: - Success Registration

extension RegistrationContainerVC: SuccessLoginScreenDelegate {
    
    func presentFeedAction() {
        coordinator?.presentAppModule()
    }
    
}
