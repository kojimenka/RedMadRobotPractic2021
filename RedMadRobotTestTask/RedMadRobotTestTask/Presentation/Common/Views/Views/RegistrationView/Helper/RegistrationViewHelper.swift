//
//  RegistrationViewHelper.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

struct RegistrationTextFieldData {
    let placeHolder: String
    var isSecure: Bool = false
}

struct RegistrationFieldData {
    let fieldData: RegistrationTextFieldData
    let validator: Validator
    var textField: NewAuthorizationTextField?
}
