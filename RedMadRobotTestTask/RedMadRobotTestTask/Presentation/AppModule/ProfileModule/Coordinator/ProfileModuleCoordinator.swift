//
//  ProfileModuleCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

final class ProfileModuleCoordinator: Coordinator {
    
    // MARK: - Public properties
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Private properties
    
    private let screenFabric: ProfileModuleScreenFabricProtocol
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        screenFabric: ProfileModuleScreenFabricProtocol = ProfileModuleScreenFabric()
    ) {
        self.navigationController = navigationController
        self.screenFabric = screenFabric
    }
    
    // MARK: - Public Properties
    
    func start() {
        let controller = screenFabric.createProfileScreen(outputDelegate: self)
        pushController(controller: controller, animated: false)
    }
    
}

extension ProfileModuleCoordinator: ProfileScreenOutputDelegate {

}
