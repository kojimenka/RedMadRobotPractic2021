//
//  SystemStorage.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import Foundation

protocol SystemStorage {
    var isUserSetPassword: Bool { get set }
    var isUserAccessBiometry: Bool { get set }
}

final class UserDefaultsSystemStorage: SystemStorage {
    
    // MARK: - Public Properties
    
    public var isUserSetPassword: Bool {
        get {
            return userDefaults.bool(forKey: UserDefaultsCase.isUserSetPassword)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsCase.isUserSetPassword)
        }
    }
    
    var isUserAccessBiometry: Bool {
        get {
            return userDefaults.bool(forKey: UserDefaultsCase.isUserAccessBiometry)
        }
        set {
            userDefaults.set(newValue, forKey: UserDefaultsCase.isUserAccessBiometry)
        }
    }

    // MARK: - Private Properties
    
    private let userDefaults: UserDefaults
    
    private struct UserDefaultsCase {
        static let isUserSetPassword = "IS_USER_SET_PASSWORD"
        static let isUserAccessBiometry = "IS_USER_ACCESS_BIOMETRY"
    }
    
    // MARK: - Init
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
}
