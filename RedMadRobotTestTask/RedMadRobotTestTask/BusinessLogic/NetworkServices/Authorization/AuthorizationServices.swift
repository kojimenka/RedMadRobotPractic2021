//
//  AuthorizationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import Apexy

import Alamofire

import RedMadRobotTestTaskAPI

protocol AuthorizationServiceProtocol {
        
    func signIn(
        credentials: Credentials,
        completion: @escaping (Result<AuthTokens, Error>) -> Void)
    -> Progress
    
    func signUp(
        credentials: Credentials,
        completion: @escaping (Result<AuthTokens, Error>) -> Void)
    -> Progress
    
    func logout(
        completion: @escaping (() -> Void))
    -> Progress
    
    func refreshToken(
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
}

final class AuthorizationServices: NSObject, AuthorizationServiceProtocol {
        
    // MARK: - Private Properties
    
    private let apiClient: Client
    private var tokenManager: TokenManager
    private let keychainManager: KeychainManager
    
    // MARK: - Init
    
    public init(
        apiClient: Client,
        tokenManager: TokenManager,
        keychainManager: KeychainManager
    ) {
        self.apiClient = apiClient
        self.tokenManager = tokenManager
        self.keychainManager = keychainManager
        super.init()
    }
    
    // MARK: - Public Methods
    
    public func logout(
        completion: @escaping (() -> Void))
    -> Progress {
        let endPoint = LogoutEndpoint()
        return apiClient.request(endPoint) { [weak self] _ in
            guard let self = self else { return }
            
            self.tokenManager.accessToken = nil
            try? self.keychainManager.deleteEntry(key: .refreshToken)
            
            completion()
        }
    }
    
    public func signIn(
        credentials: Credentials,
        completion: @escaping (Result<AuthTokens, Error>) -> Void)
    -> Progress {
        let endpoint = UserLoginEndpoint(email: credentials.email, password: credentials.password)
        return apiClient.request(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                if let token = token {
                    completion(.success(AuthTokens(token)))
                } else {
                    completion(.failure(KeychainErrors.failureCastEntry))
                }
            case .failure(let error):
                self.tokenManager.accessToken = nil
                try? self.keychainManager.deleteEntry(key: .refreshToken)
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    public func signUp(
        credentials: Credentials,
        completion: @escaping (Result<AuthTokens, Error>) -> Void)
    -> Progress {
        let endpoint = UserRegistrationEndpoint(email: credentials.email, password: credentials.password)
        
        return apiClient.request(endpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                if let token = token {
                    completion(.success(AuthTokens(token)))
                } else {
                    completion(.failure(KeychainErrors.failureCastEntry))
                }
            case .failure(let error):
                self.tokenManager.accessToken = nil
                try? self.keychainManager.deleteEntry(key: .refreshToken)
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    public func refreshToken(
        completion: @escaping (Result<Void, Error>) -> Void)
     -> Progress {
        
        guard let refreshToken = try? keychainManager.getRefreshToken() else {
            completion(.failure(KeychainErrors.entryNotExist))
            return Progress()
        }
        
        let endPoint = RefreshUserTokenEndpoint(token: refreshToken)
        return apiClient.request(endPoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.tokenManager.accessToken = token.accessToken
                guard let tokenData = token.refreshToken.data(using: .utf8) else {
                    completion(.failure(KeychainErrors.failureUpdateEntry))
                    return
                }
                try? self.keychainManager.saveRefreshToken(tokenData: tokenData)
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
