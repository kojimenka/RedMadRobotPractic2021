//
//  BirthdayValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

class RegistrationBirthdayValidator: Validator {
        
    typealias ValueType = Date
    
    // MARK: - Public Properties
    
    public var errorMessage: String = ""
    
    // MARK: - Public Methods
    
    public func isValid(value: Date?) -> Bool {
        return true
    }

}
