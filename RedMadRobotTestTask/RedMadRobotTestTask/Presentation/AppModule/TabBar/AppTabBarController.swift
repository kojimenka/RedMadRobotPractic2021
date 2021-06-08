//
//  AppTabBarController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol AppTabBarControllerDelegate: AnyObject {
    func logoutFromMain()
}

final class AppTabBarController: UITabBarController {
    
    // MARK: - Private Properties
    
    private let feedCoordinator = FeedModuleCoordinator(
        navigationController: AppNavigationController()
    )
    
    lazy private var profileScreenVC = ProfileModuleCoordinator(
        delegate: self,
        navigationController: AppNavigationController()
    )
    
    weak private var appTabBarDelegate: AppTabBarControllerDelegate?
    
    // MARK: - Init
    
    init(appTabBarDelegate: AppTabBarControllerDelegate?) {
        self.appTabBarDelegate = appTabBarDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

// MARK: - Profile Screen Delegate

extension AppTabBarController: ProfileModuleCoordinatorDelegate {
    
    func logoutFromMainModule() {
        appTabBarDelegate?.logoutFromMain()
    }
    
}
