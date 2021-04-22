//
//  ValidatePassword.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

protocol PasswordValidator: Validator {
    func checkPassword(text: String) -> Bool
}

final class UserRegistrationPasswordValidator: PasswordValidator {
    
    // MARK: - Properties
    private let errorManager = ErrorManager.shared
    private var lastCheckValue: String = ""
    
    // MARK: - Methods
    func checkPassword(text: String) -> Bool {
        lastCheckValue = text
        return searchLogic(isNeedToShowError: false)
    }
    
    public func searchForWarnings() -> Bool {
        return searchLogic(isNeedToShowError: true)
    }
    
    private func searchLogic(isNeedToShowError: Bool) -> Bool {
        print("Test")
        if lastCheckValue.count < 4 {
            if isNeedToShowError {
                errorManager.presentError(error: .errorWithTitle(title: "Пароль должен содержать больше 4 символов"))
                return true
            }
            return false
        }
        
        return isNeedToShowError ? false : true
    }
    
}
