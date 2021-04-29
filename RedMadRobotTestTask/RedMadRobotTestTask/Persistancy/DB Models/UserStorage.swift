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
}

public final class UserDefaultsUserStorage: UserStorage {
            
    // MARK: - Public Properties
    
    public var refreshToken: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCase.refreshToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsCase.refreshToken)
        }
    }
    
    public var accessToken: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsCase.accessToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsCase.accessToken)
        }
    }
        
    // MARK: - Private Properties
    
    struct UserDefaultsCase {
        static let refreshToken = "KEY_REFRESH_USER_TOKEN"
        static let accessToken = "KEY_ACCESS_USER_TOKEN"
    }
    
}
