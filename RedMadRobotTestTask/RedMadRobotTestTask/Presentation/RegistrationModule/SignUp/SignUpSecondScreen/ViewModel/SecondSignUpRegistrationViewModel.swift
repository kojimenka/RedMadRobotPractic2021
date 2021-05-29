//
//  SecondSignUpRegistrationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

protocol SecondSignUpRegistrationViewModelProtocol: RegistrationFillViewModel {
    var userInfo: UserInformation { get }
}

final class SecondSignUpRegistrationViewModel: SecondSignUpRegistrationViewModelProtocol {
    
    // MARK: - Public properties
    
    public var nameText = String()
    public var cityText = String()
    public var userInfo = UserInformation()
    
    public var allRegistrationFieldData = [
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Nickname"),
            validator: LoginValidator(),
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Name"),
            validator: NameValidator(),
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Surname"),
            validator: SurnameValidator(),
            textField: nil)
    ]
    
    // MARK: - Pubic Methods
    
    public func fillNewValues(with allRegistrationFieldData: [RegistrationFieldData]) {
        for data in allRegistrationFieldData {
            switch data.validator {
            case is NameValidator:
                userInfo.firstName = data.textField?.text ?? ""
            case is SurnameValidator:
                userInfo.lastName = data.textField?.text ?? ""
            case is LoginValidator:
                userInfo.nickname = data.textField?.text ?? ""
            default:
                break
            }
        }
    }
    
}
