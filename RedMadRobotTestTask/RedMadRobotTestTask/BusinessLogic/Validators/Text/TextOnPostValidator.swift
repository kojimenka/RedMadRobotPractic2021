//
//  TextOnPostValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 14.06.2021.
//

import Foundation

enum TextOnPostValidatorError: Error {
    case toLongPost
}

extension TextOnPostValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .toLongPost:
            return "Текст не должен содержать больше 80 симвалов"
        }
    }
}

final class TextOnPostValidatorValidator: Validator {
    
    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
    
        if value.count > 80 {
            throw TextOnPostValidatorError.toLongPost
        }
        
        return true
    }
}
