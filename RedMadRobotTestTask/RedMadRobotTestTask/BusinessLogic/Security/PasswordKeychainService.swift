//
//  PasswordKeychainService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 03.06.2021.
//

import Foundation

import LocalAuthentication

protocol KeychainPasswordService {
    func createPasswordWithBiometry(data: Data) throws
    func loadBioProtectedPassword(context: LAContext?) throws -> Data
}

final class KeychainPasswordServiceImpl: KeychainPasswordService {

    // MARK: - Public Methods
    
    public func createPasswordWithBiometry(data: Data) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: KeychainKeys.password.rawValue,
            kSecAttrAccessControl as String: KeychainManagerImpl.getBioSecAccessControl(),
            kSecValueData as String: data] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            throw KeychainErrors.failureCreateEntry
        }
    }
    
    public func loadBioProtectedPassword(context: LAContext? = nil) throws -> Data {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeychainKeys.password.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecAttrAccessControl as String: KeychainManagerImpl.getBioSecAccessControl(),
            kSecMatchLimit as String: kSecMatchLimitOne ]
        
        if let context = context {
            query[kSecUseAuthenticationContext as String] = context
            
            // Prevent system UI from automatically requesting Touc ID/Face ID authentication
            // just in case someone passes here an LAContext instance without
            // a prior evaluateAccessControl call
            query[kSecUseAuthenticationUI as String] = kSecUseAuthenticationUISkip
        }
        
        query[kSecUseOperationPrompt as String] = "Биометрия для авторизации"
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            return (dataTypeRef! as! Data)
        } else {
            throw KeychainErrors.failureReadEntry
        }
    }
}
