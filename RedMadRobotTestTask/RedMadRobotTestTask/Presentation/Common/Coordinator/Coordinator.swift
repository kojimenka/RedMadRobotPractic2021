//
//  Coordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}

extension Coordinator {
    
    func dismissController(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    func popController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    func presentController(controller: UIViewController, animated: Bool) {
        navigationController.present(controller, animated: animated)
    }
    
    func pushController(controller: UIViewController, animated: Bool) {
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    func hideTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = true
    }
    
    func showTabBar() {
        navigationController.tabBarController?.tabBar.isHidden = false
    }
    
    func disableSwipePopUp() {
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func enableSwipePopUp() {
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}
