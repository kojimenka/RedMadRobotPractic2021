//
//  RefreshTokenKeychainService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 03.06.2021.
//

import LocalAuthentication

protocol KeychainRefreshToken {
    func createToken(tokenData: Data, password: Data) throws
    func getRefreshToken(password: Data) throws -> Data
    func updateToken(tokenData: Data, password: Data) throws
}

enum KeychainRefreshTokenError: Error {
    case failureCreateAccessControl
}

final class KeychainRefreshTokenImpl: KeychainRefreshToken {
    
    // MARK: - Public Methods
    
    public func createToken(tokenData: Data, password: Data) throws {
        let accessControl = try createAccessControl()
        
        let context = LAContext()
        context.setCredential(password, type: .applicationPassword)
        
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.refreshToken.rawValue,
            kSecValueData as String: tokenData,
            kSecAttrAccessControl as String: accessControl,
            kSecUseAuthenticationContext as String: context
            
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            throw KeychainErrors.failureCreateEntry
        }
    }
    
    public func getRefreshToken(password: Data) throws -> Data {
        let accessControl = try createAccessControl()
        
        let context = LAContext()
        context.setCredential(password, type: .applicationPassword)
        
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.refreshToken.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessControl as String: accessControl,
            kSecUseAuthenticationContext as String: context
        ] as CFDictionary
        
        var resultEntry: AnyObject?
        let status = SecItemCopyMatching(query, &resultEntry)
        
        if status != errSecSuccess {
            throw KeychainErrors.failureReadEntry
        }
    
        guard let data = resultEntry as? Data else {
            throw KeychainErrors.failureReadEntry
        }
        
        return data
    }
    
    public func updateToken(tokenData: Data, password: Data) throws {
        let accessControl = try createAccessControl()
        
        let context = LAContext()
        context.setCredential(password, type: .applicationPassword)
        
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.refreshToken.rawValue,
            kSecAttrAccessControl as String: accessControl,
            kSecUseAuthenticationContext as String: context
        ] as CFDictionary
        
        let attributes = [
            kSecValueData as String: tokenData
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributes)
        
        guard status != errSecItemNotFound else {
            throw KeychainErrors.entryNotExist
        }
        
        guard status == errSecSuccess else {
            throw KeychainErrors.failureUpdateEntry
        }
    }
    
    // MARK: - Private Methods
    
    private func createAccessControl() throws -> SecAccessControl {
        var error: Unmanaged<CFError>?
        
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlocked,
            .applicationPassword,
            &error
        )
        
        if error != nil {
            throw KeychainRefreshTokenError.failureCreateAccessControl
        }
        
        return accessControl!
    }
    
}
