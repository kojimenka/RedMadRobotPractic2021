//
//  NameValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

protocol NameValidator: Validator {
    func checkName(name: String) -> Bool
}

final class RegistrationNameValidator: NameValidator {
    
    // MARK: - Properties
    private let errorManager = ErrorManager.shared
    private var lastCheckValue: String = ""
    
    // MARK: - Methods
    func checkName(name: String) -> Bool {
        lastCheckValue = name
        return searchLogic(isNeedToShowError: false)
    }
    
    public func searchForWarnings() -> Bool {
        return searchLogic(isNeedToShowError: true)
    }
    
    private func searchLogic(isNeedToShowError: Bool) -> Bool {
        if lastCheckValue.count < 2 {
            if isNeedToShowError {
                errorManager.presentError(error: .errorWithTitle(title: "Имя должно содержать больше 2 символов"))
                return true
            }
            return false
        }
        
        return isNeedToShowError ? false : true
    }
    
}
