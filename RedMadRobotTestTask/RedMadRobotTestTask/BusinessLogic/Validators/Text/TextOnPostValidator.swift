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
            return "Текст не должен содержать больше 80 слов"
        }
    }
}

final class TextOnPostValidatorValidator: Validator {
    
    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
    
        let components = value.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        
        if words.count > 80 {
            throw TextOnPostValidatorError.toLongPost
        }
        
        return true
    }
}
