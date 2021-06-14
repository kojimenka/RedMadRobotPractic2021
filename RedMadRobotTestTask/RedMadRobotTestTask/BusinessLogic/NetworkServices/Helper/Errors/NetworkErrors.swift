//
//  NetworkErrors.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 14.06.2021.
//

import Foundation

enum NetworkErrors: Error {
    case tokensNotExist
    case genericError
}

extension NetworkErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .tokensNotExist, .genericError:
            return "Произошла ошибка, повторите позже"
        }
    }
    
}
