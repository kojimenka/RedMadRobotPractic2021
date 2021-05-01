//
//  NameValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

final class RegistrationNameValidator: Validator {
    
    typealias ValueType = String
    
    // MARK: - Public Properties
    
    public var errorMessage: String = "Вы не ввели имя"

    // MARK: - Public Methods
    
    public func isValid(value: String?) -> Bool {
        guard let value = value else {
            errorMessage = "Вы не ввели имя"
            return false
        }
        
        if value.count < 2 {
            errorMessage = "Имя должно содержать больше 2 символов"
            return false
        }
        
        return true
    }
}
