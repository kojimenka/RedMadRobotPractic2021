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
