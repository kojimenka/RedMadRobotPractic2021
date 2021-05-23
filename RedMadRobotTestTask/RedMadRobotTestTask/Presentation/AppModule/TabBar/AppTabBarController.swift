//
//  AppTabBarController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class AppTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let feedCoordinator = FeedModuleCoordinator(navigationController: UINavigationController())
    private let profileScreenVC = ProfileModuleCoordinator(navigationController: UINavigationController())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTabBar()
        setController()
    }
    
    // MARK: - Private Methods
    
    private func customizeTabBar() {
        tabBar.tintColor = ColorPalette.tintOrangeColor
    }
    
    private func setController() {
        feedCoordinator.start()
        profileScreenVC.start()
        
        feedCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: R.image.feedTabBarIcon(),
            tag: 0
        )
        
        profileScreenVC.navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: R.image.accountTabBarIcon(),
            tag: 1
        )
        
        viewControllers = [feedCoordinator.navigationController, profileScreenVC.navigationController]
    }
    
}
