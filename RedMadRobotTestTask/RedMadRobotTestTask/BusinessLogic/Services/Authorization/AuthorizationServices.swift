//
//  AuthorizationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import GoogleSignIn

import FBSDKLoginKit

import Apexy

import RedMadRobotTestTaskAPI

public enum AuthorizationMethods {
    case google(presentationController: UIViewController)
    case facebook
    case vk
}

public protocol AuthorizationServiceProtocol {
    var isAuthorized: Bool { get }
    func authorizationWith(_ method: AuthorizationMethods, completion: @escaping ((Result<Void, Error>) -> Void))
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<AuthTokens?, Error>) -> Void)
    -> Progress
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<AuthTokens?, Error>) -> Void)
    -> Progress
}

public final class AuthorizationServices: NSObject, AuthorizationServiceProtocol {
        
    // MARK: - Public Properties
    
    private let apiClient: Client

    public var isAuthorized: Bool {
        return true
    }
    
    // MARK: - Private Properties
    
    public var authorizationCompletion: ((Result<Void, Error>) -> Void)?
    
    public enum AuthorizationErrors: String {
        case facebookFailure = "Ошибка FaceBook"
        case timeWaring = "Превышен лимит ожидания"
    }
    
    // MARK: - Init
    
    public init(apiClient: Client) {
        self.apiClient = apiClient
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
    
    public func logout() {
        
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<AuthTokens?, Error>) -> Void)
    -> Progress {
        let endpoint = UserLoginEndPoint(email: email, password: password)
        return apiClient.upload(endpoint, completionHandler: completion)
    }
    
    public func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<AuthTokens?, Error>) -> Void)
    -> Progress {
        let endpoint = UserRegistrationEndPoint(email: email, password: password)
        return apiClient.upload(endpoint, completionHandler: completion)
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
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error != nil else {
            authorizationCompletion?(.failure(error))
            return
        }
        
        authorizationCompletion?(.success(()))
    }
}
