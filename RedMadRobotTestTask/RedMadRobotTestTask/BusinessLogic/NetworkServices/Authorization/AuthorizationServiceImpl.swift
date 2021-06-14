//
//  AuthorizationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import Apexy

import Alamofire

import RedMadRobotTestTaskAPI

protocol AuthorizationService {
        
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

final class AuthorizationServiceImpl: NSObject, AuthorizationService {
        
    // MARK: - Private Properties
    
    private let apiClient: Client
    private var dataInRamManager: DataInRamManager
    private let keychainManager: KeychainManager
    
    // MARK: - Init
    
    public init(
        apiClient: Client,
        dataInRamManager: DataInRamManager,
        keychainManager: KeychainManager
    ) {
        self.apiClient = apiClient
        self.dataInRamManager = dataInRamManager
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
            
            self.dataInRamManager.accessToken = nil
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
                    completion(.failure(NetworkErrors.tokensNotExist))
                }
            case .failure(let error):
                self.dataInRamManager.accessToken = nil
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
                    completion(.failure(NetworkErrors.tokensNotExist))
                }
            case .failure(let error):
                self.dataInRamManager.accessToken = nil
                try? self.keychainManager.deleteEntry(key: .refreshToken)
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    public func refreshToken(
        completion: @escaping (Result<Void, Error>) -> Void)
     -> Progress {
        
        guard let passwordData = dataInRamManager.password,
              let refreshToken = try? keychainManager.getRefreshToken(passwordData: passwordData)
        else {
            completion(.failure(NetworkErrors.genericError))
            return Progress()
        }
        
        let endPoint = RefreshUserTokenEndpoint(token: refreshToken)
        
        return apiClient.request(endPoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
            
                guard let tokenData = token.refreshToken.data(using: .utf8) else {
                    completion(.failure(NetworkErrors.genericError))
                    return
                }
                
                self.dataInRamManager.accessToken = token.accessToken
                
                try? self.keychainManager.saveRefreshToken(
                    tokenData: tokenData,
                    passwordData: self.dataInRamManager.password ?? Data()
                )
                
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
