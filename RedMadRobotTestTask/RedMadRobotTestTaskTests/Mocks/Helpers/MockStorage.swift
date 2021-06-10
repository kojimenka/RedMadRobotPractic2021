//
//  MockStorage.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import Foundation

import RedMadRobotTestTask

final class MockStorage: UserStorage {
    
    var refreshToken: String?
    var accessToken: String?
    
}

final class MockTokenManager: DataInRamManager {
    
    // MARK: - Public Properties
    
    public var accessToken: String?

}

final class MockKeychainManager: KeychainManager {
    
    // MARK: - Public Properties
    
    public var savedPassword: Data = Data()
    public var savedToken: String = String()
    
    // MARK: - Public Methods
    
    func saveRefreshToken(tokenData: Data) throws {
        savedToken = String(data: tokenData, encoding: .utf8) ?? ""
    }
    
    func getRefreshToken() throws -> String {
        return savedToken
    }
    
    func savePassword(data: Data) throws {
        savedPassword = data
    }
    
    func getPassword() throws -> Data {
        return savedPassword
    }
    
    func deleteEntry(key: KeychainKeys) throws {
        
    }
    
    func deleteAllEntries() throws {
        
    }
    
}
