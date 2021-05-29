//
//  FeedModuleCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

final class FeedModuleCoordinator: Coordinator {
    
    // MARK: - Public properties
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Private properties
    
    private let screenFabric: FeedModuleFabricProtocol
    private let navBarViewModel: SetupNavBarViewModelProtocol = SetupNavBarViewModel()
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        screenFabric: FeedModuleFabricProtocol = FeedModuleFabric()
    ) {
        self.screenFabric = screenFabric
        self.navigationController = navigationController
    }
    
    // MARK: - Public Properties
    
    func start() {
        let screen = screenFabric.createFeedScreen(coordinator: self)
        pushController(controller: screen, animated: false)
        
        navBarViewModel.customizeNavBar(
            navigationBar: navigationController.navigationBar,
            navigationItem: navigationController.navigationItem,
            title: ""
        )
    }
    
    func showSearchFriendScreen() {
        let controller = screenFabric.createSearchFriendsScreen(coordinator: self)
        pushController(controller: controller, animated: true)
    }
    
    func backToFeedScreen() {
        for viewController in navigationController.viewControllers {
            guard let feedController = viewController as? FeedScreenContainerVC else { continue }
            feedController.updatePosts()
        }
    }
    
}
