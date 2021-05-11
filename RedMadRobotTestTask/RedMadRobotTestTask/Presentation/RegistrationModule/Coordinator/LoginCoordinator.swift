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
        let controller = screenFabric.createLoginScreen(outputDelegate: self)
        pushController(controller: controller, animated: false)
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        navigationController.navigationBar.isHidden = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
    }
    
}

// MARK: - Login Screen Actions

extension LoginCoordinator: LoginOutput {
    
    func pushSignInFromLogin() {
        let controller = screenFabric.createSignInScreen(outputDelegate: self)
        pushController(controller: controller, animated: true)
    }
    
    func pushSignUpFromLogin() {
        let controller = screenFabric.createSignUpScreen(outputDelegate: self)
        pushController(controller: controller, animated: true)
    }
    
}

// MARK: - SignIn Screen Actions

extension LoginCoordinator: SignInOutput {
    
    func pushSignUpFromSignIn() {
        let controller = screenFabric.createSignUpScreen(outputDelegate: self)
        pushController(controller: controller, animated: true)
    }
    
    func pushSuccessScreenFromSignIn() {
        let screen = screenFabric.createSuccessLoginScreen(outputDelegate: self)
        pushController(controller: screen, animated: true)
    }
    
}

// MARK: - SignUp Screen Actions

extension LoginCoordinator: SignUpContainerOutput {
    
    func pushSignInFromSignUp() {
        for controller in navigationController.viewControllers {
            if controller is SignInVC {
                navigationController.popToViewController(controller, animated: true)
                return
            }
        }
        
        let controller = screenFabric.createSignInScreen(outputDelegate: self)
        pushController(controller: controller, animated: true)
    }
    
    func pushSuccessScreenFromSignUp() {
        let screen = screenFabric.createSuccessLoginScreen(outputDelegate: self)
        pushController(controller: screen, animated: true)
    }
    
}

// MARK: - Success Login Screen Actions

extension LoginCoordinator: SuccessLoginScreenOutputDelegate {
    
    func presentAppModule() {
        let tabBarController = AppTabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        presentController(controller: tabBarController, animated: true)
    }
    
}
