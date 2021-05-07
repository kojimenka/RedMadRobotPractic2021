//
//  ValidatePassword.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

enum PasswordValidatorError: Error {
    case emptyPassword
    case toShortPassword
    case notContainDigits
}

extension PasswordValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyPassword:
            return "Вы не ввели пароль"
        case .toShortPassword:
            return "Пароль должен содержать больше 4 символов"
        case .notContainDigits:
            return "Пароль должен содержать хотя бы одно число"
        }
    }
}

final class PasswordValidator: Validator {

    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
        
        if value.isEmpty {
            throw PasswordValidatorError.emptyPassword
        }
        
        if value.count < 4 {
            throw PasswordValidatorError.toShortPassword
        }
        
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = value.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange == nil {
            throw PasswordValidatorError.notContainDigits
        }
        
        return true
    }
}
