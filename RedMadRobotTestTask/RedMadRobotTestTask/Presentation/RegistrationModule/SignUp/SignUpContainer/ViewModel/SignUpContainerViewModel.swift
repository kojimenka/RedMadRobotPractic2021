//
//  SignUpContainerViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 20.04.2021.
//

import UIKit

final class SignUpContainerViewModel {
    
    // MARK: - Properties
    public var currentScreen = ScreenState.firstScreen
    private var width: CGFloat = 0.0
    
    enum ScreenState {
        case firstScreen
        case secondScreen
    }
    
    // MARK: - Methods
    // swiftlint:disable line_length
    public func nextButtonAction(rootView: UIView,
                                 scrollView: UIScrollView,
                                 progressViewTrailingConstraint: NSLayoutConstraint,
                                 registeredButton: UIButton,
                                 nextButton: RegistrationNextButton) -> Bool {
        
        switch currentScreen {
        case .firstScreen:
            scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
            progressViewTrailingConstraint.constant = -width
            
            UIView.AnimationTransition.transitionChangeButtonTitle(button: nextButton,
                                                                   title: R.string.localizable.signUpRegistrationButton())
            UIView.animate(withDuration: 0.3) {
                registeredButton.alpha = 0.0
                rootView.layoutIfNeeded()
            } completion: { _ in
                registeredButton.isHidden = true
            }
            
            nextButton.setState(isButtonEnabled: false)
            currentScreen = .secondScreen
            return false
        case .secondScreen:
            return true
        }
    }
    
    public func setupScrollView(rootVC: UIViewController,
                                signUpFirstScreen: UIViewController,
                                signUpSecondScreen: UIViewController,
                                scrollView: UIScrollView) {
        
        width = rootVC.view.frame.width
        scrollView.contentSize = CGSize(width: width * 2, height: scrollView.frame.height)
        
        signUpFirstScreen.view.frame = scrollView.frame
        signUpFirstScreen.view.frame.origin = CGPoint.zero
        
        signUpSecondScreen.view.frame = scrollView.frame
        signUpSecondScreen.view.frame.origin = CGPoint(x: width, y: 0)
        
        rootVC.addChildControllerToScrollView(child: signUpFirstScreen, scrollView: scrollView)
        rootVC.addChildControllerToScrollView(child: signUpSecondScreen, scrollView: scrollView)
    }
    
}
