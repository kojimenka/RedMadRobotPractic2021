//
//  RegistrationFabric.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol RegistrationFabricProtocol {
    func createLoginScreen(
        outputDelegate: LoginOutput?
    ) -> UIViewController
    
    func createSignInScreen(
        outputDelegate: SignInOutput?
    ) -> UIViewController
    
    func createSignUpScreen(
        outputDelegate: SignUpContainerOutput
    ) -> UIViewController
    
    func createSuccessLoginScreen(
        outputDelegate: SuccessLoginScreenOutputDelegate?
    ) -> UIViewController
}

struct RegistrationFabric: RegistrationFabricProtocol {
    
    public func createLoginScreen(
        outputDelegate: LoginOutput?
    ) -> UIViewController {
        return LoginScreenVC(
            outputSubscriber: outputDelegate)
    }
    
    public func createSignInScreen(
        outputDelegate: SignInOutput?
    ) -> UIViewController {
        return SignInVC(outputSubscriber: outputDelegate)
    }

    public func createSignUpScreen(
        outputDelegate: SignUpContainerOutput
    ) -> UIViewController {
        let authorizationServices: AuthorizationServiceProtocol = ServiceLayer.shared.authorizationServices
        return SignUpContainerVC(outputSubscriber: outputDelegate,
                                 authorizationServices: authorizationServices)
    }
    
    public func createSuccessLoginScreen(
        outputDelegate: SuccessLoginScreenOutputDelegate?
    ) -> UIViewController {
        return SuccessLoginScreenVC(outputSubscriber: outputDelegate)
    }
    
}
