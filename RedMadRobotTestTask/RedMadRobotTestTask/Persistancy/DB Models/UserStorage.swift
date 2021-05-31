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
            queue.sync {
                return userDefaults.string(forKey: UserDefaultsCase.refreshToken)
            }
        }
        set {
            queue.sync {
                userDefaults.set(newValue, forKey: UserDefaultsCase.refreshToken)
            }
        }
    }
    
    public var accessToken: String? {
        get {
            queue.sync {
                return userDefaults.string(forKey: UserDefaultsCase.accessToken)
            }
        }
        set {
            queue.sync {
                userDefaults.set(newValue, forKey: UserDefaultsCase.accessToken)
            }
        }
    }
        
    // MARK: - Private Properties
    
    private let userDefaults: UserDefaults
    
    private let queue = DispatchQueue(label: "StorageQueue")
    
    private struct UserDefaultsCase {
        static let refreshToken = "KEY_REFRESH_USER_TOKEN"
        static let accessToken = "KEY_ACCESS_USER_TOKEN"
    }
    
    // MARK: - Init
    
    init(
        userDefaults: UserDefaults = UserDefaults.standard
    ) {
        self.userDefaults = userDefaults
    }

}
