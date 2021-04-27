//
//  UserStorage.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Foundation

protocol UserStorage {
    var refreshToken: String? { get }
    var accessToken: String? { get }
}

final class UserDefaultsUserStorage: UserStorage {
    
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

}
