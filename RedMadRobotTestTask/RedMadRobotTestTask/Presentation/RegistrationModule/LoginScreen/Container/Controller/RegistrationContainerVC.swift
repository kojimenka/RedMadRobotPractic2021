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
    
    func loginUser(email: String, password: String) {
        requestViewModel.loginUser(
            email: email,
            password: password
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator?.pushSuccessRegistration(subscriber: self)
            case .failure:
                print("Fail")
            }
        }
    }
    
}

// MARK: - SignUp Delegate

extension RegistrationContainerVC: SignUpContainerDelegate {
    
    func registrateUser(email: String, password: String) {
        requestViewModel.registrateUser(
            email: email,
            password: password
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator?.pushSuccessRegistration(subscriber: self)
            case .failure:
                print("Fail")
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
