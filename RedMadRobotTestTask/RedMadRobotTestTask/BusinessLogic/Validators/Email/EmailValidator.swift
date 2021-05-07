//
//  EmailValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

enum EmailValidatorError: Error {
    case emptyEmail
    case toShortEmail
    case emailNotContainAT
}

extension EmailValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Вы не ввели email"
        case .emailNotContainAT:
            return "Email Должен содержать @"
        case .toShortEmail:
            return "Email Должен содержать больше 7 символов"
        }
    }
}

final class EmailValidator: Validator {
        
    // MARK: - Public Methods
    
    func isValid(value: String) throws -> Bool {
        if value.isEmpty {
            throw EmailValidatorError.emptyEmail
        }
        
        if value.count < 7 {
            throw EmailValidatorError.toShortEmail
        }
        
        if !value.contains(where: { $0 == "@" }) {
            throw EmailValidatorError.emailNotContainAT
        }
        
        return true
    }
    
}
