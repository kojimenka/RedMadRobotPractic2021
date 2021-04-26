//
//  AuthorizationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import GoogleSignIn

import FBSDKLoginKit

enum AuthorizationMethods {
    case google(presentationController: UIViewController)
    case facebook
    case vk
}

protocol AuthorizationServiceProtocol {
    var isAuthorized: Bool { get }
    func authorizationWith(_ method: AuthorizationMethods, completion: @escaping ((Result<Void, Error>) -> Void))
    func signIn(user: UserInfo, completion: @escaping ((Result<Void, Error>) -> Void))
    func signUp(user: UserInfo)
}

final class AuthorizationServices: NSObject, AuthorizationServiceProtocol {
        
    // MARK: - Public Properties

    public var isAuthorized: Bool {
        return true
    }
    
    // MARK: - Private Properties
    
    private var authorizationCompletion: ((Result<Void, Error>) -> Void)?
    
    private enum AuthorizationErrors: String {
        case facebookFailure = "Ошибка FaceBook"
        case timeWaring = "Превышен лимит ожидания"
    }
    
    private var dummyRes: Bool {
        return Int.random(in: 0...1) == 0 ? false : true // True - Success res, False - failure res
    }
    
    // MARK: - Init
    
    override init() {
        super.init()
        self.initialSetup()
    }
    
    // MARK: - Public Methods
    
    public func authorizationWith(
        _ method: AuthorizationMethods,
        completion: @escaping ((Result<Void, Error>) -> Void)
    ) {
        authorizationCompletion = completion
        switch method {
        case .google(presentationController: let controller):
            authoriseWithGoogle(controller: controller)
        case .facebook:
            authoriseWithFacebook()
        case .vk:
            break
        }
    }
    
    func logout() {
        
    }
    
    func signIn(user: UserInfo, completion: @escaping ((Result<Void, Error>) -> Void)) {
        if dummyRes {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                completion(.success(()))
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let error = ValidationError(message: AuthorizationErrors.timeWaring.rawValue)
                completion(.failure(error))
            }
        }
    }
    
    func signUp(user: UserInfo) {
        
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = "595173877503-1onfl4cl6cnj4isap013fvcq85goqa9j.apps.googleusercontent.com"
    }
    
    private func authoriseWithGoogle(controller: UIViewController) {
        GIDSignIn.sharedInstance()?.presentingViewController = controller
        GIDSignIn.sharedInstance().signIn()
    }
    
    private func authoriseWithFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["user_hometown"],
                           from: nil) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.authorizationCompletion?(.failure(error))
                return
            }
            
            if let result = result {
                print("Token: \(result.token?.tokenString ?? "")")
                self.authorizationCompletion?(.success(()))
            } else {
                let error = ValidationError(message: AuthorizationErrors.facebookFailure.rawValue)
                self.authorizationCompletion?(.failure(error))
            }
        }
    }
    
}

// MARK: - Google Authorization Delegate

extension AuthorizationServices: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error != nil else {
            authorizationCompletion?(.failure(error))
            return
        }
        
        authorizationCompletion?(.success(()))
    }
}
