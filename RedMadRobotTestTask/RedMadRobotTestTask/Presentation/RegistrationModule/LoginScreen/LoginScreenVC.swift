//
//  LoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol LoginScreenDelegate: AnyObject {
    func signInButtonAction()
    func signUpButtonAction()
}

final class LoginScreenVC: UIViewController {
    
    // MARK: - Private Properties
    
    weak private var delegate: LoginScreenDelegate?
    private let authorizationService: AuthorizationServiceProtocol
    
    // MARK: - Initializers
    
    init(
        subscriber: LoginScreenDelegate?,
        authorizationService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices
    ) {
        self.delegate = subscriber
        self.authorizationService = authorizationService
        super.init(nibName: nil, bundle: nil)
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
        delegate?.signInButtonAction()
    }
    
    @IBAction private func registrationButtonAction(_ sender: Any) {
        delegate?.signUpButtonAction()
    }
    
    @IBAction private func loginWithGoogleAction(_ sender: Any) {
        authorizationService.authorizationWith(.google(presentationController: self)) { _ in }
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        authorizationService.authorizationWith(.facebook) { _ in }
    }
}
