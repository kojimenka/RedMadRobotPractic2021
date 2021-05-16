//
//  SignInRegistrationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import UIKit

protocol RegistrationFillViewModel {
    var allRegistrationFieldData: [RegistrationFieldData] { get }
    func fillNewValues(with allRegistrationFieldData: [RegistrationFieldData])
}

protocol SignInRegistrationViewModelProtocol: RegistrationFillViewModel {
    var emailText: String { get }
    var passwordText: String { get }
}

final class SignInRegistrationViewModel: SignInRegistrationViewModelProtocol {
    
    // MARK: - Public properties
    
    public var emailText = String()
    public var passwordText = String()
    
    public var allRegistrationFieldData = [
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Email"),
            validator: EmailValidator(),
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(
                placeHolder: "Password",
                isSecure: true
            ),
            validator: PasswordValidator(),
            textField: nil)
    ]
    
    // MARK: - Pubic Methods
    
    public func fillNewValues(with allRegistrationFieldData: [RegistrationFieldData]) {
        for data in allRegistrationFieldData {
            switch data.validator {
            case is EmailValidator:
                emailText = data.textField?.text ?? ""
            case is PasswordValidator:
                passwordText = data.textField?.text ?? ""
            default:
                break
            }
        }
    }
    
}
