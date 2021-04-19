//
//  LoginValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

import Foundation

protocol LoginValidator: Validator {
    func checkLogin(login: String) -> Bool
}

final class UserRegistrationLoginValidator: LoginValidator {
    
    // MARK: - Properties
    private let errorManager = ErrorManager.shared
    private var lastCheckValue: String = ""
        
    // MARK: - Methods
    func checkLogin(login: String) -> Bool {
        lastCheckValue = login
        return searchLogic(isNeedToShowError: false)
    }
    
    func searchForWarnings() -> Bool {
        return searchLogic(isNeedToShowError: true)
    }
    
    private func searchLogic(isNeedToShowError: Bool) -> Bool {
        if lastCheckValue.count < 7 {
            if isNeedToShowError {
                errorManager.presentError(error: .errorWithTitle(title: "Логин Должен содержать больше 7 символов"))
                return true
            }
        }
        
        return isNeedToShowError ? false : true
    }
    
}
