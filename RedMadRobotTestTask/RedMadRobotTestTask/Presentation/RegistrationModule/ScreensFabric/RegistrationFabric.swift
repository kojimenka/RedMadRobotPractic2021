//
//  RegistrationFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol RegistrationFabricProtocol {
    func createLoginScreen(
        delegate: LoginScreenDelegate?
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
        delegate: LoginScreenDelegate?
    ) -> UIViewController {
        return LoginScreenVC(delegate: delegate)
    }
    
    public func createSignInScreen(
        subscriber: SignInDelegate?
    ) -> UIViewController {
        return SignInVC(subscriber: subscriber)
    }

    public func createSignUpScreen(
        subscriber: SignUpContainerDelegate?
    ) -> UIViewController {
        return SignUpContainerVC(subscriber: subscriber)
    }
    
    public func createSuccessLoginScreen(
        subscriber: SuccessLoginScreenDelegate?
    ) -> UIViewController {
        return SuccessLoginScreenVC(subscriber: subscriber)
    }
    
}
