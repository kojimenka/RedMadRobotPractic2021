//
//  AppDelegate.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 17.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Private Properties
    
    private let keychainManager: KeychainManager = ServiceLayer.shared.keychainManager

    // MARK: - Public Methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    -> Bool {
        
        /// Если приложения запущено в режиме тестирования, не заходим в основное приложения, что бы code coverage был максимально правдивым
        guard !GlobalFlags.isTesting else { return false }
        
        checkKeychain()
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions)
    -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Private Methods
    
    /// Проверяем было ли удалено приложения. Так как keychain сохраняет данные даже после удаления приложения с устройства, мы должны очищать keychain при первом старте.
    private func checkKeychain() {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "isKeychainCheckForFirstStart") {
            try? keychainManager.deleteEntry(key: .password)
            try? keychainManager.deleteEntry(key: .refreshToken)
            userDefaults.set(true, forKey: "isKeychainCheckForFirstStart")
        }
    }
    
}
