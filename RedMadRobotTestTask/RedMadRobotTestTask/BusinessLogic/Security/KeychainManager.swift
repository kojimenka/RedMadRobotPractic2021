//
//  KeychainManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 03.06.2021.
//

import Foundation

import LocalAuthentication

/// Enum со всеми ключами для Keychain
public enum KeychainKeys: String, CaseIterable {
    case password
    case refreshToken
}

enum KeychainManagerErrors: Error {
    case failureCastRefreshToken
}

enum KeychainErrors: Error {
    case entryNotExist
    case failureCastEntry
    
    case failureCreateEntry
    case failureReadEntry
    case failureUpdateEntry
    case failureDeleteEntry
}

public protocol KeychainManager {
    
    func saveRefreshToken(tokenData: Data, passwordData: Data) throws
    func getRefreshToken(passwordData: Data) throws -> String
    
    func savePassword(data: Data) throws
    func getPassword(laContext: LAContext?) throws -> Data
    
    func deleteEntry(key: KeychainKeys) throws
    
    func isEntryExist(key: KeychainKeys) -> Bool
}

/// Фасад связывающий сервис по сохранению пароля и обновлению токена. Каждый из сервисов независим и его можно использовать без фасад.
public final class KeychainManagerImpl: KeychainManager {
    
    // MARK: - Private Properties
    
    private let refreshTokenService: KeychainRefreshToken
    private let passwordService: KeychainPasswordService
    
    // MARK: - Init
    
    init(
        refreshTokenService: KeychainRefreshToken = KeychainRefreshTokenImpl(),
        passwordService: KeychainPasswordService = KeychainPasswordServiceImpl()
    ) {
        self.refreshTokenService = refreshTokenService
        self.passwordService = passwordService
    }
    
    // MARK: - Public Methods
    
    // MARK: - Password Block
    
    /// Метод для сохранения пароля.
    /// - Parameter data: Пароль который нужно сохранить, должен приходить в формате Data. Это удобно если мы захотим  пароль как-то обезопасить с помощью шифрования
    public func savePassword(data: Data) throws {
        try passwordService.createPasswordWithBiometry(data: data)
    }
    
    /// Метод получения пароля
    /// - Returns: Возможно пароль был сохранен с каким-то шифрованием, и его необходимо декодировать, поэтому возвращаем Data
    public func getPassword(laContext: LAContext?) throws -> Data {
        return try passwordService.loadBioProtectedPassword(context: laContext)
    }
    
    // MARK: - Refresh Token Block
    
    /// Метод для получения токена.
    /// - Returns: Для удобства возвращаем всегда строку, у нас нет необходимости возвращать токен в сыром Data формате
    public func getRefreshToken(passwordData: Data) throws -> String {
        let tokenData = try refreshTokenService.getRefreshToken(password: passwordData)
        
        guard let stringToken = String(data: tokenData, encoding: .utf8) else {
            throw KeychainManagerErrors.failureCastRefreshToken
        }
        
        return stringToken
    }
    
    /// Метод для сохранения токена. Происходит проверка, существует ли токен в Keychain, если существует – мы его обновляем, если нет - создаем токен в Keychain
    public func saveRefreshToken(tokenData: Data, passwordData: Data) throws {
        do {
            try refreshTokenService.updateToken(tokenData: tokenData, password: passwordData)
        } catch let error {
            if error as? KeychainErrors == KeychainErrors.entryNotExist {
                try refreshTokenService.createToken(tokenData: tokenData, password: passwordData)
            }
        }
    }
    
    // MARK: - General Block
    
    /// Метод для удаление конретной Entry в Keychain
    /// - Parameter key: передаем ключ Entry которую нужно удалить
    public func deleteEntry(key: KeychainKeys) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ] as CFDictionary
        
        let res = SecItemDelete(query)
        
        guard res != errSecItemNotFound else {
            throw KeychainErrors.failureDeleteEntry
        }
    }
    
    /// Метод для получение инфомации о существованиии нужного элемента в keychain
    /// - Parameter key: Один из ключей внутри enum-a KeychainKeys
    public func isEntryExist(key: KeychainKeys) -> Bool {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecUseAuthenticationUI as String: kSecUseAuthenticationUIFail] as CFDictionary
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        return status == noErr || status == errSecInteractionNotAllowed || status == errSecAuthFailed
    }
    
    /// Для заполнения AccessControl для биометрии всегда используем один и тот же код
    static func getBioSecAccessControl() -> SecAccessControl {
        var access: SecAccessControl?
        var error: Unmanaged<CFError>?
        
        if #available(iOS 11.3, *) {
            access = SecAccessControlCreateWithFlags(
                nil,
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                .biometryCurrentSet,
                &error)
        } else {
            access = SecAccessControlCreateWithFlags(
                nil,
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                .biometryCurrentSet,
                &error)
        }
        precondition(access != nil, "SecAccessControlCreateWithFlags failed")
        return access!
    }
    
}
