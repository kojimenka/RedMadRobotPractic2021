//
//  AuthorizationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import GoogleSignIn

import FBSDKLoginKit

protocol AuthorizationViewModelProtocol {
    func authorizationWith(_ method: AuthorizationViewModel.AuthorizationMethods)
}

final class AuthorizationViewModel: NSObject, AuthorizationViewModelProtocol {
    
    // MARK: - Properties
    public var endAuthorise: ((Result<String, Error>) -> Void)?
    
    enum AuthorizationMethods {
        case google(presentationController: UIViewController)
        case facebook
        case vk
    }
    
    // MARK: - Init
    override init() {
        super.init()
        self.initialSetup()
    }
    
    // MARK: - Methods
    private func initialSetup() {
        GIDSignIn.sharedInstance().delegate = self
    }
    
    public func authorizationWith(_ method: AuthorizationMethods) {
        switch method {
        case .google(presentationController: let controller):
            GIDSignIn.sharedInstance()?.presentingViewController = controller
            authoriseWithGoogle()
        case .facebook:
            authoriseWithFacebook()
        case .vk:
            break
        }
    }
    
    private func authoriseWithGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func authoriseWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["user_hometown"],
                           from: nil) { (result, error) in
            if let result = result {
                print("Token: \(result.token?.tokenString ?? "")")
            }
        }
    }
    
}

// MARK: - Google Authorization {
extension AuthorizationViewModel: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        guard error != nil else {
//            endAuthorize?(.failure(error))
//            return
//        }
        
//        endAuthorize?(.success(signIn.clientID))
        print(signIn.clientID)
    }
}
