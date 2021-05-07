//
//  DefaultServiceErrors.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import Foundation

enum DefaultServiceErrors: Error {
    case nilToken
}

extension DefaultServiceErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .nilToken:
            return "Произошла ошибка, повторите попытку позже"
        }
    }
}
