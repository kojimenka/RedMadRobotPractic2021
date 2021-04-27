//
//  LoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

import RedMadRobotTestTaskAPI

final class LoginScreenVC: UIViewController {
    
    // MARK: - Private Properties
    
    private let authorizationViewModel: AuthorizationServiceProtocol
    
    // MARK: - Initializers
    
    init(authorizationViewModel: AuthorizationServiceProtocol) {
        self.authorizationViewModel = authorizationViewModel
        super.init(nibName: R.nib.loginScreenVC.name, bundle: R.nib.loginScreenVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        
//        ServiceLayer.shared.userInfoService.getUserPosts(token: "Test") { result in
//            switch result {
//            case .success(let info):
//                print("Check Success \(info)")
//            case .failure(let err):
//                print("Check Failure \(err.localizedDescription)")
//            }
//        }
    
    }
    
    // MARK: - IBAction
    
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
    
    @IBAction private func loginWithGoogleAction(_ sender: Any) {
        authorizationViewModel.authorizationWith(.google(presentationController: self)) { _ in }
    }
    
    @IBAction private func loginWithFacebook(_ sender: Any) {
        authorizationViewModel.authorizationWith(.facebook) { _ in }
    }
}
