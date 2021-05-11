//
//  ProfileModuleScreenFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import UIKit

protocol ProfileModuleScreenFabricProtocol {
    func createProfileScreen(
        outputDelegate: ProfileScreenOutputDelegate?
    ) -> UIViewController
}

struct ProfileModuleScreenFabric: ProfileModuleScreenFabricProtocol {
    
    public func createProfileScreen(
        outputDelegate: ProfileScreenOutputDelegate?
    ) -> UIViewController {
        return ProfileScreenVC(outputSubscriber: outputDelegate)
    }
    
}
