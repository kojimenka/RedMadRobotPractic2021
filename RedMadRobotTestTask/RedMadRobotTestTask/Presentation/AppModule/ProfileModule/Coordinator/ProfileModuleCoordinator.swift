//
//  ProfileModuleCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

protocol ProfileModuleCoordinatorDelegate: AnyObject {
    func logoutFromMainModule()
}

final class ProfileModuleCoordinator: Coordinator {
    
    // MARK: - Public properties
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Private properties
    
    private let screenFabric: ProfileModuleScreenFabricProtocol
    weak private var delegate: ProfileModuleCoordinatorDelegate?
    
    // MARK: - Init
    
    init(
        delegate: ProfileModuleCoordinatorDelegate,
        navigationController: UINavigationController,
        screenFabric: ProfileModuleScreenFabricProtocol = ProfileModuleScreenFabric()
    ) {
        self.delegate = delegate
        self.navigationController = navigationController
        self.screenFabric = screenFabric
    }
    
    // MARK: - Public Properties
    
    func start() {
        let controller = screenFabric.createProfileScreen(coordinator: self)
        pushController(controller: controller, animated: false)
    }
    
    func logoutFromApp() {
        delegate?.logoutFromMainModule()
    }
    
    func pushSearchNewFriends() {
        let controller = SearchFriendsContainerVC()
        pushController(controller: controller, animated: true)
    }
    
}
