//
//  LoginValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

enum LoginValidatorError: Error {
    case emptyLogin
    case toShortLogin
    case toLongLogin
}

extension LoginValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyLogin:
            return "Вы не ввели логин"
        case .toShortLogin:
            return "Логин должен содержать больше 7 символов"
        case .toLongLogin:
            return "Логин должен содержать меньше 14 символов"
        }
    }
}

final class LoginValidator: Validator {
        
    // MARK: - Public Methods

    func isValid(value: String) throws -> Bool {
        
        if value.isEmpty {
            throw LoginValidatorError.emptyLogin
        }
        
        if value.count < 7 {
            throw LoginValidatorError.toShortLogin
        }
        
        if value.count > 14 {
            throw LoginValidatorError.toLongLogin
        }
        
        return true
    }
    
}
