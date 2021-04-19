//
//  BirthdayValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

protocol DayValidator: Validator {
    func checkDay(date: Date) -> Bool
}

final class RegistrationBirthdayValidator: DayValidator {
    
    func checkDay(date: Date) -> Bool {
        return true
    }
    
    func searchForWarnings() -> Bool {
        false
    }
}
