//
//  AppCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class AppCoordinator {
    
    // MARK: - Properties
    private let isLaunchedBefore = false
    
    // MARK: - Methods
    public func startFlow() -> UIViewController {
        if !isLaunchedBefore {
            return createLoginScreenWithNavController()
        } else {
            return AppTabBarController()
        }
    }
    
    private func createLoginScreenWithNavController() -> UINavigationController {
        
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        
        let authorizationViewModel = AuthorizationViewModel()
        
        let loginVC = LoginScreenVC(authorizationViewModel: authorizationViewModel)
        navController.pushViewController(loginVC, animated: false)
        
        return navController
    }
}
