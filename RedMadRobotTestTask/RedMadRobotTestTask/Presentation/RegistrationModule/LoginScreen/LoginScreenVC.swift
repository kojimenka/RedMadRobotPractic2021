//
//  LoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol LoginOutput: AnyObject {
    func pushSignInFromLogin()
    func pushSignUpFromLogin()
}

final class LoginScreenVC: UIViewController {
    
    // MARK: - Private Properties
    
    weak private var outputDelegate: LoginOutput?
    private let authorizationService: AuthorizationServiceProtocol
    
    // MARK: - Initializers
    
    init(
        outputSubscriber: LoginOutput?,
        authorizationService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices
    ) {
        self.outputDelegate = outputSubscriber
        self.authorizationService = authorizationService
        super.init(nibName: R.nib.loginScreenVC.name, bundle: R.nib.loginScreenVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - IBAction
    
    @IBAction private func enterWithMailOrPhoneButtonAction(_ sender: Any) {
        outputDelegate?.pushSignInFromLogin()
    }
    
    @IBAction private func registrationButtonAction(_ sender: Any) {
        outputDelegate?.pushSignUpFromLogin()
    }
    
    @IBAction private func loginWithGoogleAction(_ sender: Any) {
        authorizationService.authorizationWith(.google(presentationController: self)) { _ in }
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        authorizationService.authorizationWith(.facebook) { _ in }
    }
}
