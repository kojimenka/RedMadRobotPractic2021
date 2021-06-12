//
//  FeedModuleFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

protocol FeedModuleFabricProtocol {
    func createFeedScreen(
        coordinator: FeedModuleCoordinator?
    ) -> UIViewController
    
    func createSearchFriendsScreen(
        coordinator: FeedModuleCoordinator?
    ) -> UIViewController
}

struct FeedModuleFabric: FeedModuleFabricProtocol {
    
    public func createFeedScreen(
        coordinator: FeedModuleCoordinator?
    ) -> UIViewController {
        return FeedScreenContainerVC(coordinator: coordinator)
    }
    
    public func createSearchFriendsScreen(
        coordinator: FeedModuleCoordinator?
    ) -> UIViewController {
        return SearchFriendsContainerVC()
    }
    
}
