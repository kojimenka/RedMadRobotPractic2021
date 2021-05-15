//
//  AppCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
        
    // MARK: - Private Properties
    
    private let isLaunchedBefore = false
        
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    // MARK: - Public Properties
    
    func start() {
        if !isLaunchedBefore {
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            childCoordinators.append(loginCoordinator)
            loginCoordinator.start()
        } else {
            let tabBarController = AppTabBarController()
            navigationController.pushViewController(tabBarController, animated: false)
        }
    }

}
