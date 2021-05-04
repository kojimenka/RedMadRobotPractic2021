//
//  EmailValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

final class RegistrationEmailValidator: Validator {
    
    typealias ValueType = String
    
    // MARK: - Public Properties
    
    public var errorMessage: String = "Вы не ввели email"

    // MARK: - Public Methods
    
    public func isValid(value: String) -> Bool {
        if value.isEmpty {
            errorMessage = "Вы не ввели email"
            return false
        }
        
        if value.count < 7 {
            errorMessage = "Email Должен содержать больше 7 символов"
            return false
        }
        
        if !value.contains(where: { $0 == "@" }) {
            errorMessage = "Email Должен содержать @"
            return false
        }
        
        return true
    }
}
