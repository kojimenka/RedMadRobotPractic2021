//
//  LoginScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

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
        
//        ServiceLayer.shared.authorizationServices.signIn(email: "TestUser345@test.com",
//                                                         password: "1234Testing") { result in
//            switch result {
//            case .success:
//                print("Check Success")
//            case .failure(let error):
//                print("Check \(error.localizedDescription)")
//            }
//        }
        
//        MockChangeUserInfo().changeUserInfo()
        
//        MockPostData().addNewPost()
        
//        ServiceLayer.shared.userInfoService.getUserPosts { result in
//            switch result {
//            case .success(let info):
//                print("Check Success \(info.map({$0.text}))")
//            case .failure(let error):
//                print("Check \(error.localizedDescription)")
//            }
//        }
//        
        
//        ServiceLayer.shared.authorizationServices.refreshToken { result in
//            switch result {
//            case .success:
//                print("Check Success")
//            case .failure(let error):
//                print("Check \(error.localizedDescription)")
//            }
//        }
//
//        let id = "c1f8515d-4b58-48ff-b22d-74d4f764b6e2"
        
//        ServiceLayer.shared.authorizationServices.logout { result in
//            switch result {
//            case .success(let info):
//                print("Check Success \(info)")
//            case .failure(let error):
//                print("Check \(error.localizedDescription)")
//            }
//        }
        
//        ServiceLayer.shared.searchService.getSortedPosts(predicate: "") { result in
//            switch result {
//            case .success(let info):
//                print("Check Success \(info)")
//            case .failure(let error):
//                print("Check \(error.localizedDescription)")
//            }
//        }
        
        navigationController?.navigationBar.isHidden = true
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
