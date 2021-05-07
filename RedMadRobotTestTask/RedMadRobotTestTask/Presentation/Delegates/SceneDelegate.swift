//
//  SceneDelegate.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 17.04.2021.
//

import UIKit

import FBSDKCoreKit

struct GlobalFlags {
    static var isTesting: Bool {
        UserDefaults.standard.bool(forKey: "isTesting")
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard !GlobalFlags.isTesting else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        let appCoordinator = AppCoordinator()
        window?.rootViewController = appCoordinator.startFlow()
    }
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else { return }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

}
