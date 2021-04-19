//
//  EmailValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 19.04.2021.
//

protocol EmailValidator: Validator {
    func checkEmail(email: String) -> Bool
}

final class UserRegistrationEmailValidator: EmailValidator {
    
    // MARK: - Properties
    private let errorManager = ErrorManager.shared
    private var lastCheckValue: String = ""
    
    // MARK: - Methods
    func checkEmail(email: String) -> Bool {
        lastCheckValue = email
        return searchLogic(isNeedToShowError: false)
    }
    
    public func searchForWarnings() -> Bool {
        return searchLogic(isNeedToShowError: true)
    }
    
    private func searchLogic(isNeedToShowError: Bool) -> Bool {
        if lastCheckValue.count < 7 {
            if isNeedToShowError {
                errorManager.presentError(error: .errorWithTitle(title: "Email Должен содержать больше 7 символов"))
                return true
            }
            return false
        }
        
        if !lastCheckValue.contains(where: { $0 == "@" }) {
            if isNeedToShowError {
                errorManager.presentError(error: .errorWithTitle(title: "Email Должен содержать @"))
                return true
            }
            return false
        }
        
        return isNeedToShowError ? false : true
    }
    
}
