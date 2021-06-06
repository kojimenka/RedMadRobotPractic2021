//
//  PasswordKeychainService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 03.06.2021.
//

import Foundation

protocol KeychainPasswordService {
    func createPassword(data: Data) throws
    func getPassword() throws -> Data
    func updatePassword(data: Data) throws
    func deletePassword()
}

final class KeychainPasswordServiceImpl: KeychainPasswordService {

    // MARK: - Public Methods
    
    public func createPassword(data: Data) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.password.rawValue,
            kSecValueData as String: data
        ] as CFDictionary

        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            throw KeychainErrors.failureCreateEntry
        }
    }

    public func getPassword() throws -> Data {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.password.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?

        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == noErr {
            guard let passwordData = dataTypeRef as? Data else {
                throw KeychainErrors.failureCastEntry
            }
            return passwordData
        } else {
            throw KeychainErrors.failureReadEntry
        }
    }

    public func updatePassword(data: Data) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.password.rawValue
        ] as CFDictionary

        let attributes = [
            kSecValueData as String: data
        ] as CFDictionary
        
        let status = SecItemUpdate(query, attributes)
        
        guard status != errSecItemNotFound else {
            throw KeychainErrors.entryNotExist
        }
        
        guard status == errSecSuccess else {
            throw KeychainErrors.failureUpdateEntry
        }
    }
    
    public func deletePassword() {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.password.rawValue
        ] as CFDictionary
        
        SecItemDelete(query)
    }

}
