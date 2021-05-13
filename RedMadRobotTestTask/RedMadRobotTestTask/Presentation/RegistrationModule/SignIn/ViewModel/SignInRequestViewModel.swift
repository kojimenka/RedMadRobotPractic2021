//
//  SignInRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 14.05.2021.
//

import Foundation

protocol SignInRequestViewModelProtocol {
    func registrateUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SignInRequestViewModel: SignInRequestViewModelProtocol {
    
    // MARK: - Properties
    
    private let registrationService: AuthorizationServiceProtocol
    
    // MARK: - Init
    
    init(registrationService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices) {
        self.registrationService = registrationService
    }
    
    // MARK: - Methods
    
    func registrateUser(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.success(()))
    }
    
}
