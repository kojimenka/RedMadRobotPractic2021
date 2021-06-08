//
//  ProfileModuleScreenFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

protocol ProfileModuleScreenFabricProtocol {
    func createProfileScreen(
        coordinator: ProfileModuleCoordinator
    ) -> UIViewController
}

struct ProfileModuleScreenFabric: ProfileModuleScreenFabricProtocol {
    
    public func createProfileScreen(
        coordinator: ProfileModuleCoordinator
    ) -> UIViewController {
        return ProfileScreenContainerVC(coordinator: coordinator)
    }
    
}
