//
//  RegistrationViewHelper.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 15.05.2021.
//

import Foundation

/// Данные для заполнения полей
struct RegistrationTextFieldData {
    let placeHolder: String
    var isSecure: Bool = false
    var isDatePickerNeeded: Bool = false
}

/// Структуры формирующая итоговое поле
struct RegistrationFieldData {
    let fieldData: RegistrationTextFieldData
    let validator: Validator
    var textField: AuthorizationTextField?
}
