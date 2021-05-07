//
//  NameValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

enum NameValidatorError: Error {
    case emptyName
    case toShortName
}

extension NameValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyName:
            return "Вы не ввели имя"
        case .toShortName:
            return "Имя должно содержать больше 2 символов"
        }
    }
}

final class NameValidator: Validator {
    
    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
        
        if value.isEmpty {
            throw NameValidatorError.emptyName
        }
        
        if value.count < 2 {
            throw NameValidatorError.toShortName
        }
        
        return true
    }
}
