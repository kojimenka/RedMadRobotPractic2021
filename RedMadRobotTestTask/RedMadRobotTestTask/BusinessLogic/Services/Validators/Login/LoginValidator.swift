//
//  LoginValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

final class RegistrationLoginValidator: Validator {
    
    typealias ValueType = String
    
    // MARK: - Public Properties
    
    var errorMessage: String = "Вы не ввели данные"
    
    // MARK: - Public Methods

    func isValid(value: String?) -> Bool {
        guard let value = value else {
            errorMessage = "Вы не ввели данные"
            return false
        }
        
        if value.count < 7 {
            errorMessage = "Логин Должен содержать больше 7 символов"
            return false
        }
        
        if value.count > 14 {
            errorMessage = "Логин Должен содержать меньше 14 символов"
            return false
        }
        
        return true
    }
}
