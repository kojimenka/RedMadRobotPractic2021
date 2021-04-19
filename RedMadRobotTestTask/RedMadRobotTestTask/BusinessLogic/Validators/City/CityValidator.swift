//
//  CityValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

protocol CityValidator: Validator {
    func checkCity(city: String) -> Bool
}

final class RegistrationCityValidator: CityValidator {
    
    // MARK: - Properties
    private let errorManager = ErrorManager.shared
    private var lastCheckValue: String = ""
    
    // MARK: - Methods
    func checkCity(city: String) -> Bool {
        lastCheckValue = city
        return searchLogic(isNeedToShowError: false)
    }
    
    public func searchForWarnings() -> Bool {
        return searchLogic(isNeedToShowError: true)
    }
    
    private func searchLogic(isNeedToShowError: Bool) -> Bool {
        if lastCheckValue.count < 5 {
            if isNeedToShowError {
                errorManager.presentError(error: .errorWithTitle(title: "Город должен содержать больше 5 символов"))
                return true
            }
            return false
        }
        
        return isNeedToShowError ? false : true
    }
    
}
