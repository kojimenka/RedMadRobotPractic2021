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
        setController()
    }
    
    // MARK: - Methods
    private func setController() {
        feedCoordinator.start()
        profileScreenVC.start()
        
        let feedTabBarTitle = R.string.localizable.feedTabBarTitle()
        feedCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: feedTabBarTitle,
            image: .init(),
            tag: 0
        )
        
        let profileTabBarTitle = R.string.localizable.profileTabBarTitle()
        profileScreenVC.navigationController.tabBarItem = UITabBarItem(
            title: profileTabBarTitle,
            image: .init(),
            tag: 1
        )
        
        viewControllers = [feedCoordinator.navigationController, profileScreenVC.navigationController]
    }
    
}
