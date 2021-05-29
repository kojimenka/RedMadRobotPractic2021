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

protocol SignInRegistrationViewModelProtocol {
    var emailText: String { get }
    var passwordText: String { get }
    var allRegistrationsFields: [UITextField] { get }
    func fillNewValues(with textField: UITextField)
}

final class SignInRegistrationViewModel: SignInRegistrationViewModelProtocol {
    
    // MARK: - Public properties
    
    public var emailText = String()
    public var passwordText = String()
    
    public let emailTextField: NewAuthorizationTextField = {
        let textField = NewAuthorizationTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    public let passwordTextField: NewAuthorizationTextField = {
        let textField = NewAuthorizationTextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy public var allRegistrationsFields: [UITextField] = [
        emailTextField,
        passwordTextField
    ]
    
    // MARK: - Pubic Methods
    
    public func fillNewValues(with textField: UITextField) {
        switch textField {
        case emailTextField:
            emailText = emailTextField.text ?? ""
        case passwordTextField:
            passwordText = passwordTextField.text ?? ""
        default:
            break
        }
    }
    
}
