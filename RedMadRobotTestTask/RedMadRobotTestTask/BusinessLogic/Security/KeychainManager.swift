//
//  KeychainManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 03.06.2021.
//

import Foundation

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
    
    func saveRefreshToken(tokenData: Data) throws
    func getRefreshToken() throws -> String
    
    func savePassword(data: Data) throws
    func getPassword() throws -> Data
    
    func deleteEntry(key: KeychainKeys) throws
    func deleteAllEntries() throws
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
    
    /// Метод для сохранения пароля. Происходит проверка, существует ли пароль в Keychain, если существует – мы его обновляем, если нет - создаем пароль в Keychain
    /// - Parameter data: Пароль который нужно сохранить, должен приходить в формате Data. Это удобно если мы захотим  пароль как-то обезопасить с помощью шифрования
    public func savePassword(data: Data) throws {
        do {
            try passwordService.updatePassword(data: data)
        } catch let error {
            if error as? KeychainErrors == KeychainErrors.entryNotExist {
                try passwordService.createPassword(data: data)
            }
        }
    }
    
    /// Метод получения пароля
    /// - Returns: Возможно пароль был сохранен с каким-то шифрованием, и его необходимо декодировать, поэтому возвращаем Data
    public func getPassword() throws -> Data {
        return try passwordService.getPassword()
    }
    
    // MARK: - Refresh Token Block
    
    /// Метод для получения токена.
    /// - Returns: Для удобства возвращаем всегда строку, у нас нет необходимости возвращать токен в сыром Data формате
    public func getRefreshToken() throws -> String {
        let passwordData = try passwordService.getPassword()
        let tokenData = try refreshTokenService.getRefreshToken(password: passwordData)
        
        guard let stringToken = String(data: tokenData, encoding: .utf8) else {
            throw KeychainManagerErrors.failureCastRefreshToken
        }
        
        return stringToken
    }
    
    /// Метод для сохранения токена. Происходит проверка, существует ли токен в Keychain, если существует – мы его обновляем, если нет - создаем токен в Keychain
    public func saveRefreshToken(tokenData: Data) throws {
        do {
            try updateRefreshToken(tokenData: tokenData)
        } catch let error {
            if error as? KeychainErrors == KeychainErrors.entryNotExist {
                try createRefreshToken(tokenData: tokenData)
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
    
    /// Метод для удаления всех Entry в Keychain
    public func deleteAllEntries() throws {
        try KeychainKeys.allCases.forEach { try deleteEntry(key: $0) }
    }
    
    // MARK: - Private Methods
    
    private func createRefreshToken(tokenData: Data) throws {
        let passwordData = try passwordService.getPassword()
        try refreshTokenService.createToken(tokenData: tokenData, password: passwordData)
    }
    
    private func updateRefreshToken(tokenData: Data) throws {
        let passwordData = try passwordService.getPassword()
        try refreshTokenService.updateToken(tokenData: tokenData, password: passwordData)
    }
    
}
