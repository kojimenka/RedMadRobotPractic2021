//
//  RegistrationFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol RegistrationFabricProtocol {
    func createLoginScreen(
        subscriber: LoginScreenDelegate?
    ) -> UIViewController
    
    func createSignInScreen(
        subscriber: SignInDelegate?
    ) -> UIViewController
    
    func createSignUpScreen(
        subscriber: SignUpContainerDelegate?
    ) -> UIViewController
    
    func createSuccessLoginScreen(
        subscriber: SuccessLoginScreenDelegate?
    ) -> UIViewController
}

struct RegistrationFabric: RegistrationFabricProtocol {
    
    public func createLoginScreen(
        subscriber: LoginScreenDelegate?
    ) -> UIViewController {
        return LoginScreenVC(subscriber: subscriber)
    }
    
    public func createSignInScreen(
        subscriber: SignInDelegate?
    ) -> UIViewController {
        return SignInVC(subscriber: subscriber)
    }

    public func createSignUpScreen(
        subscriber: SignUpContainerDelegate?
    ) -> UIViewController {
        let authorizationServices: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices
        return SignUpContainerVC(subscriber: subscriber,
                                 authorizationServices: authorizationServices)
    }
    
    public func createSuccessLoginScreen(
        subscriber: SuccessLoginScreenDelegate?
    ) -> UIViewController {
        return SuccessLoginScreenVC(subscriber: subscriber)
    }
    
}
