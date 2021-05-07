//
//  CityValidator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

enum CityValidatorError: Error {
    case emptyCity
    case toShortCityName
}

extension CityValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyCity:
            return "Вы не ввели название города"
        case .toShortCityName:
            return "Город должен содержать больше 4 символов"
        }
    }
}

final class CityValidator: Validator {
    
    // MARK: - Public Methods
    
    public func isValid(value: String) throws -> Bool {
        if value.isEmpty {
            throw CityValidatorError.emptyCity
        }
        
        if value.count < 4 {
            throw CityValidatorError.toShortCityName
        }
        
        return true
    }
}
