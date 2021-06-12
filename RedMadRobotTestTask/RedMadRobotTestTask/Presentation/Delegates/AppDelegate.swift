//
//  AppDelegate.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 17.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let keychainManager: KeychainManager = ServiceLayer.shared.keychainManager

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        guard !GlobalFlags.isTesting else { return false }
        checkKeychain()
        return true
    }
    
    private func checkKeychain() {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "isKeychainCheckForFirstStart") {
            try? keychainManager.deleteEntry(key: .password)
            try? keychainManager.deleteEntry(key: .refreshToken)
            userDefaults.set(true, forKey: "isKeychainCheckForFirstStart")
        }
    }

    // MARK: - UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions)
    -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}
