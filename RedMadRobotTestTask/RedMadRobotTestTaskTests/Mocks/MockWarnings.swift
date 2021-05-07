//
//  MockWarnings.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import Foundation

enum MockWarnings: Error {
    case mockError
}

extension MockWarnings: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .mockError:
            return "Some error"
        }
    }
}
