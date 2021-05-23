//
//  SurnameValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 24.05.2021.
//

import Foundation

enum SurnameValidatorError: Error {
    case emptyName
    case toShortName
}

extension SurnameValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Вы не ввели фамилию"
        case .toShortName:
            return "Фамилия должно содержать больше 2 символов"
        }
    }
}

final class SurnameValidator: Validator {
    
    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
        
        if value.isEmpty {
            throw SurnameValidatorError.emptyName
        }
        
        if value.count < 2 {
            throw SurnameValidatorError.toShortName
        }
        
        return true
    }
}

