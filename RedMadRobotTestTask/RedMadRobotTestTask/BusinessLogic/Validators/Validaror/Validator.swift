//
//  Validator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import Foundation

// MARK: - Validator Protocol

/// Основной протокол для валидации данных
protocol Validator {
    func isValid(value: String) throws -> Bool
}
