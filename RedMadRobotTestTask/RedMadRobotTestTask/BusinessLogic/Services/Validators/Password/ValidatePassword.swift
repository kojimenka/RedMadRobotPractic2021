//
//  ValidatePassword.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

final class RegistrationPasswordValidator: Validator {
    
    typealias ValueType = String
    
    // MARK: - Public Properties
    
    public var errorMessage: String = "Вы не ввели данные почты"
    
    // MARK: - Public Methods
    
    public func isValid(value: String?) -> Bool {
        guard let value = value else {
            errorMessage = "Вы не ввели данные"
            return false
        }
        
        if value.count < 4 {
            errorMessage = "Пароль должен содержать больше 4 символов"
            return false
        }
        
        return true
    }
}
