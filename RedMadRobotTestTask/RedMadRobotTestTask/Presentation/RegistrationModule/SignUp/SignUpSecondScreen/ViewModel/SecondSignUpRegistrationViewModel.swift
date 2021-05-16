//
//  SecondSignUpRegistrationViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

protocol SecondSignUpRegistrationViewModelProtocol: RegistrationFillViewModel {
    var nameText: String { get }
    var cityText: String { get }
}

final class SecondSignUpRegistrationViewModel: SecondSignUpRegistrationViewModelProtocol {
    
    // MARK: - Public properties
    
    public var nameText = String()
    public var cityText = String()
    
    public var allRegistrationFieldData = [
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Name"),
            validator: NameValidator(),
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "Birthday"),
            validator: LoginValidator(),
            textField: nil),
        
        RegistrationFieldData(
            fieldData: RegistrationTextFieldData(placeHolder: "City"),
            validator: CityValidator(),
            textField: nil)
    ]
    
    // MARK: - Pubic Methods
    
    public func fillNewValues(with allRegistrationFieldData: [RegistrationFieldData]) {
        for data in allRegistrationFieldData {
            switch data.validator {
            case is NameValidator:
                nameText = data.textField?.text ?? ""
            case is CityValidator:
                cityText = data.textField?.text ?? ""
            default:
                break
            }
        }
    }
    
}
