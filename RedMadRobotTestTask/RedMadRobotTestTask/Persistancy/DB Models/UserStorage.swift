//
//  UserStorage.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Foundation

import RedMadRobotTestTaskAPI

public protocol UserStorage {
    var refreshToken: String? { get set }
    var accessToken: String? { get set }
    func saveTokens(res: Result<AuthTokens?, Error>)
    func removeTokens()
}

public final class UserDefaultsUserStorage: UserStorage {
            
    // MARK: - Public Properties
    
    public var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCase.refreshToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsCase.refreshToken.rawValue)
        }
    }
    
    public var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCase.accessToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsCase.accessToken.rawValue)
        }
    }
        
    // MARK: - Private Properties
    
    private enum UserDefaultsCase: String {
        case refreshToken = "KEY_REFRESH_USER_TOKEN"
        case accessToken = "KEY_ACESS_USER_TOKEN"
    }
    
    // MARK: - Public Methods
    
    public func saveTokens(res: Result<AuthTokens?, Error>) {
        switch res {
        case .success(let token):
            self.accessToken = token?.accessToken
            self.refreshToken = token?.refreshToken
        case .failure:
            removeTokens()
        }
    }
    
    public func removeTokens() {
        self.accessToken = nil
        self.refreshToken = nil
    }
    
}
