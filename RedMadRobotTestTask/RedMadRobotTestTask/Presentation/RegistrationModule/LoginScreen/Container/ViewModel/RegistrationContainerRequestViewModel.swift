//
//  RegistrationContainerRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 14.05.2021.
//

import Foundation

protocol RegistrationContainerRequestViewModelProtocol {
    func loginUser(
        credentials: Credentials,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func registrateUser(
        credentials: Credentials,
        userInfo: UserInformation,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class RegistrationContainerRequestViewModel: RegistrationContainerRequestViewModelProtocol {
    
    // MARK: - Properties
    
    private let registrationService: AuthorizationServiceProtocol
    private let userService: UserInfoServiceProtocol
    
    private var completion: ((Result<Void, Error>) -> Void)?
    
    // MARK: - Init
    
    init(
        registrationService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices,
        userService: UserInfoServiceProtocol = ServiceLayer.shared.userInfoService
    ) {
        self.userService = userService
        self.registrationService = registrationService
    }
    
    // MARK: - Methods
    
    func loginUser(
        credentials: Credentials,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        _ = registrationService.signIn(credentials: credentials) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func registrateUser(
        credentials: Credentials,
        userInfo: UserInformation,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.completion = completion
        
        _ = registrationService.signUp(credentials: credentials) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.addUserInformation(userInfo: userInfo)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func addUserInformation(userInfo: UserInformation) {
        _ = userService.updateUserInfo(user: userInfo, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.completion?(.success(()))
            case .failure(let error):
                self.completion?(.failure(error))
            }
        })
    }
    
}
