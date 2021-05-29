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
    
    private let isTokenInvalid: Bool
        
    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        userStorage: UserStorage = UserDefaultsUserStorage()
    ) {
        isTokenInvalid = userStorage.accessToken != nil
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }
    
    // MARK: - Public Properties
    
    func start() {
        if !isTokenInvalid {
            let loginCoordinator = LoginCoordinator(navigationController: navigationController)
            childCoordinators.append(loginCoordinator)
            loginCoordinator.start()
        } else {
            let tabBarController = AppTabBarController()
            navigationController.pushViewController(tabBarController, animated: false)
        }
    }

}
