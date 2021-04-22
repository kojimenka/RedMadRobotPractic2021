//
//  LoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class LoginScreenVC: UIViewController {
    
    // MARK: - Properties
    private let authorizationViewModel: AuthorizationViewModelProtocol
    
    // MARK: - Init
    init(authorizationViewModel: AuthorizationViewModelProtocol) {
        self.authorizationViewModel = authorizationViewModel
        super.init(nibName: R.nib.loginScreenVC.name, bundle: R.nib.loginScreenVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Private Methods
    @IBAction private func enterWithMailOrPhoneButtonAction(_ sender: Any) {
        let signInVC = SignInVC(uiViewModel: SetupNavBarViewModel(),
                                checkKeyboardViewModel: CheckKeyboardViewModel(subscriber: nil))
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @IBAction private func registrationButtonAction(_ sender: Any) {
        let signUpVC = SignUpContainerVC(viewModel: SetupNavBarViewModel(),
                                         checkKeyboardViewModel: CheckKeyboardViewModel(subscriber: nil))
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK: - Auth buttons
    @IBAction private func loginWithGoogleAction(_ sender: Any) {
        authorizationViewModel.authorizationWith(.google(presentationController: self))
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        authorizationViewModel.authorizationWith(.facebook)
    }
}
