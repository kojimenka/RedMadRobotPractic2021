//
//  SecondSignUpRegistrationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

protocol SecondSignUpRegistrationViewModelProtocol: RegistrationFillViewModel {
    var userInfo: AddUserInformationModel { get }
}

final class SecondSignUpRegistrationViewModel: SecondSignUpRegistrationViewModelProtocol {
    
    // MARK: - Public properties

    public var userInfo = AddUserInformationModel()
    
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
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Birthday", isDatePickerNeeded: true),
            validator: BirthdayValidator(),
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
            case is BirthdayValidator:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                guard let stringDate = data.textField?.text,
                      let date = dateFormatter.date(from: stringDate) else { return }

                userInfo.birthDay = date
            default:
                break
            }
        }
        
        print(userInfo)
    }
    
}
