//
//  ValidatePassword.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

final class RegistrationPasswordValidator: Validator {
    
    typealias ValueType = String
    
    // MARK: - Public Properties
    
    public var errorMessage: String = "Вы не ввели пароль"
    
    // MARK: - Public Methods
    
    public func isValid(value: String) -> Bool {
        
        if value.isEmpty {
            errorMessage = "Вы не ввели пароль"
            return false
        }
        
        if value.count < 4 {
            errorMessage = "Пароль должен содержать больше 4 символов"
            return false
        }
        
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = value.rangeOfCharacter(from: decimalCharacters)
        
        if decimalRange == nil {
            errorMessage = "Пароль должен содержать хотя бы одно число"
            return false
        }
        
        return true
    }
}
