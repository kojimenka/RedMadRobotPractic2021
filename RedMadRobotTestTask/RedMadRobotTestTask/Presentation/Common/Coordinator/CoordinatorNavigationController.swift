//
//  CoordinatorNavigationController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 09.05.2021.
//

import UIKit

final class CoordinatorNavigationController: UINavigationController {
    
    public var navigationControllerWasPopped: (() -> Void)?
    
    func start() {
        delegate = self
    }
    
}

extension CoordinatorNavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from)
        else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        navigationControllerWasPopped?()
    }
}
