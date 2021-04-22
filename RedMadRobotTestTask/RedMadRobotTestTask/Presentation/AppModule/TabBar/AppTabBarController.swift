//
//  AppTabBarController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class AppTabBarController: UITabBarController {
    
    // MARK: - Properties
    private let feedScreenVC = FeedScreenVC()
    private let profileScreenVC = ProfileScreenVC()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
    }
    
    // MARK: - Methods
    private func setController() {
        let feedNavController = UINavigationController()
        feedNavController.pushViewController(feedScreenVC, animated: false)
        let feedTabBarTitle = R.string.localizable.feedTabBarTitle()
        feedNavController.tabBarItem = UITabBarItem(title: feedTabBarTitle, image: .init(), tag: 0)
        
        let profileNavController = UINavigationController()
        profileNavController.pushViewController(profileScreenVC, animated: false)
        let profileTabBarTitle = R.string.localizable.profileTabBarTitle()
        let profileTabBarItem = UITabBarItem(title: profileTabBarTitle, image: .init(), tag: 1)
        profileNavController.tabBarItem = profileTabBarItem
        
        viewControllers = [feedNavController, profileNavController]
    }
    
}
