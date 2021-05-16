//
//  APIError.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Foundation

/// Error from API.
public struct APIError: Decodable, Error, LocalizedError {

    public struct Code: RawRepresentable, Decodable, Equatable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }

    /// Error code.
    public let code: Code

    /// Error description.
    public let message: String?
    
    public var errorDescription: String? {
        switch code {
        case APIError.Code.invalidCredentials:
            return "Email или пароль указаны неверно"
        case APIError.Code.tokenInvalid:
            return "Проблема с access или refresh токеном"
        case APIError.Code.emailInvalid:
            return "Email имеет недопустимый формат"
        case APIError.Code.passwordInvalid:
            return "Пароль имеет недопустимый формат"
        case APIError.Code.duplicateUser:
            return "Такой пользователь уже зарегистрирован"
        case APIError.Code.serializationError:
            return "Входные данные не соответствуют модели"
        case APIError.Code.invalidFile:
            return "Запрошенное изображение не найдено"
        case APIError.Code.tooBigFile:
            return "Загружаемое изображение больше 5mb"
        case APIError.Code.badFileExtension:
            return "Изображение имеет недопустимый формат"
        default:
            return message
        }
    }

    public init(
        code: Code,
        message: String? = nil) {

        self.code = code
        self.message = message
    }
}

// MARK: - General Error Code

extension APIError.Code {
    
    public static let invalidCredentials = APIError.Code("INVALID_CREDENTIALS")
    
    public static let tokenInvalid = APIError.Code("INVALID_TOKEN")
    
    public static let emailInvalid = APIError.Code("EMAIL_VALIDATION_ERROR")
    
    public static let passwordInvalid = APIError.Code("PASSWORD_VALIDATION_ERROR")
    
    public static let duplicateUser = APIError.Code("DUPLICATE_USER_ERROR")
    
    public static let serializationError = APIError.Code("SERIALIZATION_ERROR")
    
    public static let invalidFile = APIError.Code("FILE_NOT_FOUND_ERROR")
    
    public static let tooBigFile = APIError.Code("TOO_BIG_FILE_ERROR")
    
    public static let badFileExtension = APIError.Code("BAD_FILE_EXTENSION_ERROR")
    
    public static let genericError = APIError.Code("GENERIC_ERROR")
    
    public static let unknownError = APIError.Code("UNKNOWN_ERROR")
}
