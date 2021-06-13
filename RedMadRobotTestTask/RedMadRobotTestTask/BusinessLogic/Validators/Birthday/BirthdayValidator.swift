//
//  BirthdayValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 13.06.2021.
//

import Foundation

enum BirthdayValidatorError: Error {
    case emptyDate
}

extension BirthdayValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyDate:
            return "Вы не ввели дату рождения"
        }
    }
}

final class BirthdayValidator: Validator {
    
    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
        
        if value.isEmpty {
            throw BirthdayValidatorError.emptyDate
        }
        
        return true
    }
}
