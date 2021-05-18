//
//  LoginCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

final class LoginCoordinator: Coordinator {
    
    // MARK: - Public properties
    
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    
    // MARK: - Private properties
    
    private let screenFabric: RegistrationFabricProtocol
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        screenFabric: RegistrationFabricProtocol = RegistrationFabric()
    ) {
        self.screenFabric = screenFabric
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        let controller = RegistrationContainerVC(coordinator: self)
        pushController(controller: controller, animated: false)
        setupNavBar()
    }
    
    // MARK: - Public Methods
    
    public func pushLoginScreen(subscriber: LoginScreenDelegate?) {
        let controller = screenFabric.createLoginScreen(subscriber: subscriber)
        pushController(controller: controller, animated: false)
    }
    
    func pushSignIn(subscriber: SignInDelegate?) {
        let controller = screenFabric.createSignInScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func pushSignUp(subscriber: SignUpContainerDelegate?) {
        let controller = screenFabric.createSignUpScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func pushSuccessRegistration(subscriber: SuccessLoginScreenDelegate?) {
        let controller = screenFabric.createSuccessLoginScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func pushSignInFromSignUp(subscriber: SignInDelegate?) {
        for controller in navigationController.viewControllers where controller is SignInVC {
            navigationController.popToViewController(controller, animated: true)
            return
        }
        
        let controller = screenFabric.createSignInScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func pushSignUpFromSignIn(subscriber: SignUpContainerDelegate?) {
        for controller in navigationController.viewControllers where controller is SignUpContainerVC {
            navigationController.popToViewController(controller, animated: true)
            return
        }
        
        let controller = screenFabric.createSignUpScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func presentAppModule() {
        let tabBarController = AppTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        presentController(controller: tabBarController, animated: true)
    }
    
    func presentLoader(stopLoading: @escaping (() -> Void)) {
        let loader = LoaderVC()
        loader.modalPresentationStyle = .overCurrentContext
        loader.modalTransitionStyle = .crossDissolve
        
        loader.stopLoad = {
            stopLoading()
        }
        
        presentController(controller: loader, animated: false)
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
    }
    
}
