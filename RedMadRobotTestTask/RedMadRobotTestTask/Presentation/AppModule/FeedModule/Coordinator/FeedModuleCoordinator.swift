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
        let screen = screenFabric.createFeedScreen(outputDelegate: self)
        pushController(controller: screen, animated: false)
    }
    
}

// MARK: - Feed Screen delegate

extension FeedModuleCoordinator: FeedScreenOutPutDelegate {
    func showSearchFriendScreen() {
        let controller = screenFabric.createSearchFriendsScreen(outputDelegate: self)
        pushController(controller: controller, animated: true)
    }
}

// MARK: - Search Screen delegate

extension FeedModuleCoordinator: SearchFriendsOutputDelegate {
    func backToFeedScreen() {
        for viewController in navigationController.viewControllers {
            guard let feedController = viewController as? NewFeedScreenVC else { continue }
            feedController.updatePosts()
        }
    }
}
