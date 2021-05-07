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
    
    func authorizationWith(
        _ method: AuthorizationMethods,
        completion: @escaping ((Result<Void, Error>) -> Void))
    
    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    func logout(
        completion: @escaping (() -> Void))
    -> Progress
    
    func refreshToken(
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
}

public final class AuthorizationServices: NSObject, AuthorizationServiceProtocol {
        
    // MARK: - Public Properties
    
    private let apiClient: Client
    private var storage: UserStorage

    public var isAuthorized: Bool {
        return storage.accessToken != nil
    }
    
    // MARK: - Private Properties
    
    public var authorizationCompletion: ((Result<Void, Error>) -> Void)?
    
    public enum AuthorizationErrors: String {
        case facebookFailure = "Ошибка FaceBook"
        case timeWaring = "Превышен лимит ожидания"
    }
    
    // MARK: - Init
    
    public init(apiClient: Client, storage: UserStorage) {
        self.apiClient = apiClient
        self.storage = storage
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
    
    public func logout(
        completion: @escaping (() -> Void))
    -> Progress {
        let endPoint = LogoutEndpoint()
        return apiClient.request(endPoint) { [weak self] _ in
            guard let self = self else { return }
            
            self.storage.accessToken = nil
            self.storage.refreshToken = nil
            
            completion()
        }
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endpoint = UserLoginEndpoint(email: email, password: password)
        return apiClient.request(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.storage.accessToken = token?.accessToken
                self.storage.refreshToken = token?.refreshToken
                completion(.success(()))
            case .failure(let error):
                self.storage.accessToken = nil
                self.storage.refreshToken = nil
                completion(.failure(error))
            }
        }
    }
    
    public func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endpoint = UserRegistrationEndpoint(email: email, password: password)
        
        return apiClient.request(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.storage.accessToken = token?.accessToken
                self.storage.refreshToken = token?.refreshToken
                completion(.success(()))
            case .failure(let error):
                self.storage.accessToken = nil
                self.storage.refreshToken = nil
                completion(.failure(error))
            }
        }
    }
    
    public func refreshToken(
        completion: @escaping (Result<Void, Error>) -> Void)
     -> Progress {
        let endPoint = RefreshUserTokenEndpoint(token: storage.refreshToken ?? "")
        return apiClient.request(endPoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.storage.accessToken = token.accessToken
                self.storage.refreshToken = token.refreshToken
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
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
//                let error = ValidationError(message: AuthorizationErrors.facebookFailure.rawValue)
//                self.authorizationCompletion?(.failure(error))
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
