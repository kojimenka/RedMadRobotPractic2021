//
//  RegistrationContainerRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 14.05.2021.
//

import Foundation

protocol RegistrationContainerRequestViewModelProtocol {
    func loginUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func registrateUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class RegistrationContainerRequestViewModel: RegistrationContainerRequestViewModelProtocol {
    
    // MARK: - Properties
    
    private let registrationService: AuthorizationServiceProtocol
    
    // MARK: - Init
    
    init(registrationService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices) {
        self.registrationService = registrationService
    }
    
    // MARK: - Methods
    
    func loginUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }
    
    func registrateUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }
    
}
