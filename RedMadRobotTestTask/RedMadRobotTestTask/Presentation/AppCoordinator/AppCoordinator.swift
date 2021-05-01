//
//  AppCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class AppCoordinator {
    
    // MARK: - Private Properties
    
    private let isLaunchedBefore = false
    private let authorizationService: AuthorizationServiceProtocol
        
    // MARK: - Init
    
    init(authorizationService: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices) {
        self.authorizationService = authorizationService
    }
    
    // MARK: - Public Properties
    
    public func startFlow() -> UIViewController {
        if !isLaunchedBefore {
            return createLoginScreenWithNavController()
        } else {
            return AppTabBarController()
        }
    }
    
    // MARK: - Private Properties
    
    private func createLoginScreenWithNavController() -> UINavigationController {
        
        let navController = UINavigationController()
        navController.navigationBar.isHidden = true
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        
        let loginVC = LoginScreenVC(authorizationViewModel: authorizationService)
        navController.pushViewController(loginVC, animated: false)
        
        return navController
    }
}
