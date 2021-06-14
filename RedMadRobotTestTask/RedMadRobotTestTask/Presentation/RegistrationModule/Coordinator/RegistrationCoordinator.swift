//
//  LoginCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

final class RegistrationCoordinator: Coordinator {
    
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
    
    func start() {}
    
    // MARK: - Public Methods
    
    public func pushLoginScreen(delegate: LoginScreenDelegate?) {
        let controller = screenFabric.createLoginScreen(delegate: delegate)
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
    
    func pushLockScreen(delegate: LockScreenDelegate, token: AuthTokens) {
        disableSwipePopUp()
        let controller = LockScreenVC(currentState: .lockInRegistration(token: token), delegate: delegate)
        pushController(controller: controller, animated: true)
    }
    
    func pushSuccessRegistration(subscriber: SuccessLoginScreenDelegate?) {
        disableSwipePopUp()
        let controller = screenFabric.createSuccessLoginScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func pushSignInFromSignUp(subscriber: SignInDelegate?) {
        // Проверяем нет ли в стеке нужного контроллера, помогает избежать зациклинности показа 
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
    
    func pushSecondSignUpScreen() {
        guard let signUpController = navigationController.viewControllers.last as? SignUpContainerVC else { return }
        signUpController.showSecondScreen()
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
    
}
