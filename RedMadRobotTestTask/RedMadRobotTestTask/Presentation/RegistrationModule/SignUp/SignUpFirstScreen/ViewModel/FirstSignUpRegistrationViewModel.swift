//
//  FirstSignUpRegistrationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

protocol FirstSignUpRegistrationViewModelProtocol: RegistrationFillViewModel {
    var userCredentials: Credentials { get }
}

final class FirstSignUpRegistrationViewModel: FirstSignUpRegistrationViewModelProtocol {
    
    // MARK: - Public properties

    public var userCredentials = Credentials()
    
    public var allRegistrationFieldData = [
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Электронная почта"),
            validator: EmailValidator(),
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(
                placeHolder: "Пароль",
                isSecure: true
            ),
            validator: PasswordValidator(),
            textField: nil)
    ]
    
    // MARK: - Pubic Methods
    
    /// Пробегаемся по заполненному данными массиву и заполняем этими данными модель данных
    public func fillNewValues(with allRegistrationFieldData: [RegistrationFieldData]) {
        for data in allRegistrationFieldData {
            switch data.validator {
            case is EmailValidator:
                userCredentials.email = data.textField?.text ?? ""
            case is PasswordValidator:
                userCredentials.password = data.textField?.text ?? ""
            default:
                break
            }
        }
    }
    
}
