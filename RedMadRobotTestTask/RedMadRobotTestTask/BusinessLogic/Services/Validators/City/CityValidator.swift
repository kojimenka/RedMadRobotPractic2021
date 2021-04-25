//
//  CityValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

final class RegistrationCityValidator: Validator {
    
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
            errorMessage = "Город должен содержать больше 4 символов"
            return false
        }
        
        return true
    }
}
