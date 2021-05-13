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
    
    // MARK: - Init
    
    init(coordinator: LoginCoordinator) {
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
    
    func successSignIn() {
        coordinator?.pushSuccessRegistration(subscriber: self)
    }
    
    func signUpButtonActionFromSignIn() {
        coordinator?.pushSignUpFromSignIn(subscriber: self)
    }
    
}

// MARK: - SignUp Delegate

extension RegistrationContainerVC: SignUpContainerDelegate {
    
    func signInButtonActionFromSignUp() {
        coordinator?.pushSignInFromSignUp(subscriber: self)
    }
    
    func successRegistration() {
        coordinator?.pushSuccessRegistration(subscriber: self)
    }
    
}

// MARK: - Success Registration

extension RegistrationContainerVC: SuccessLoginScreenDelegate {
    
    func presentFeedAction() {
        coordinator?.presentAppModule()
    }
    
}
