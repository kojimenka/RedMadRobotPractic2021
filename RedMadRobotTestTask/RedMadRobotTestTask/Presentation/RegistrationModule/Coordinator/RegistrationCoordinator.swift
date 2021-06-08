//
//  LoginCoordinator.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject {
    func endRegistrationFlow(token: AuthTokens)
}

final class RegistrationCoordinator: Coordinator {
    
    // MARK: - Public properties
    
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    
    // MARK: - Private properties
    
    private let screenFabric: RegistrationFabricProtocol
    weak private var delegate: LoginCoordinatorDelegate?
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController,
        delegate: LoginCoordinatorDelegate?,
        screenFabric: RegistrationFabricProtocol = RegistrationFabric()
    ) {
        self.screenFabric = screenFabric
        self.delegate = delegate
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        let controller = RegistrationContainerVC(coordinator: self)
        pushController(controller: controller, animated: false)
        setupNavBar()
    }
    
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
    
    func pushSuccessRegistration(subscriber: SuccessLoginScreenDelegate?) {
        let controller = screenFabric.createSuccessLoginScreen(subscriber: subscriber)
        pushController(controller: controller, animated: true)
    }
    
    func pushSignInFromSignUp(subscriber: SignInDelegate?) {
        /// Проверяем нет ли в стеке нужного контроллера, помогает избежать зациклиново показа 
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
    
    func presentAppModule(token: AuthTokens) {
        delegate?.endRegistrationFlow(token: token)
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
