//
//  MockStorage.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import Foundation

import RedMadRobotTestTask

import LocalAuthentication

final class MockTokenManager: DataInRamManager {
    
    // MARK: - Public Properties
    
    public var accessToken: String?
    public var password: Data?
    
}

final class MockKeychainManager: KeychainManager {
    
    // MARK: - Public Properties
    
    public var savedPassword: Data = Data()
    public var savedToken: String = String()
    
    // MARK: - Public Methods
    
    func saveRefreshToken(tokenData: Data, passwordData: Data) throws {
        savedToken = String(data: tokenData, encoding: .utf8) ?? ""
    }
    
    func getRefreshToken(passwordData: Data) throws -> String {
        return savedToken
    }
    
    func getPassword(laContext: LAContext?) throws -> Data {
        return savedPassword
    }
    
    func isEntryExist(key: KeychainKeys) -> Bool {
        return false
    }
    
    func savePassword(data: Data) throws {
        savedPassword = data
    }
    
    func deleteEntry(key: KeychainKeys) throws {
        
    }
    
    func deleteAllEntries() throws {
        
    }
    
}
