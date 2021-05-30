//
//  AuthorizationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import Apexy

import Alamofire

import RedMadRobotTestTaskAPI

public protocol AuthorizationServiceProtocol {
    
    var isAuthorized: Bool { get }
    
    func signIn(
        credentials: Credentials,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    func signUp(
        credentials: Credentials,
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

    public var isAuthorized: Bool {
        return storage.accessToken != nil
    }
    
    // MARK: - Private Properties
    
    private let apiClient: Client
    private var storage: UserStorage
    
    // MARK: - Init
    
    public init(apiClient: Client, storage: UserStorage) {
        self.apiClient = apiClient
        self.storage = storage
        super.init()
    }
    
    // MARK: - Public Methods
    
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
        credentials: Credentials,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endpoint = UserLoginEndpoint(email: credentials.email, password: credentials.password)
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
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    public func signUp(
        credentials: Credentials,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endpoint = UserRegistrationEndpoint(email: credentials.email, password: credentials.password)
        
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
                completion(.failure(error.unwrapAFError()))
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
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
}

public extension Error {
    func unwrapAFError() -> Error {
        guard let afError = asAFError else { return self }
        
        if case .responseValidationFailed(let reason) = afError,
           case .customValidationFailed(let underLayingError) = reason {
            return underLayingError
        }

        return self
    }
}
