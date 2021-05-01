//
//  SignInVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class SignInVC: UIViewController {

    // MARK: - IBOutlet
    
    @IBOutlet private weak var enterButton: RegistrationNextButton!
    @IBOutlet private weak var signInView: RegistrationView!
    @IBOutlet private weak var registrationButtonBottomConstraint: NSLayoutConstraint!

    // MARK: - Private Properties
    
    private let uiViewModel: SignInViewModelProtocol?
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    private let registrationService = ServiceLayer.shared.authorizationServices
    
    // MARK: - Initializers
    
    init(uiViewModel: SignInViewModelProtocol, checkKeyboardViewModel: CheckKeyboardViewModel) {
        self.uiViewModel = uiViewModel
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: R.nib.signInVC.name, bundle: R.nib.signInVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - IBAction
    
    @IBAction private func signUpButtonAction(_ sender: Any) {
        let signUpVC = SignUpContainerVC(viewModel: SetupNavBarViewModel(),
                                         checkKeyboardViewModel: CheckKeyboardViewModel(subscriber: nil))
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        guard enterButton.isButtonEnable == true else { signInView.checkForWarning(controller: self); return }
        registrateUser()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        uiViewModel?.customizeNavBar(navigationBar: navigationController?.navigationBar,
                                     navigationItem: navigationItem,
                                     title: R.string.localizable.signInNavBarTitle())
    }
    
    private func setupViews() {
        checkKeyboardViewModel.delegate = self
        signInView.delegate = self
        enterButton.isButtonEnable = false
        self.hideKeyboardWhenTappedAround()
    }
    
    private func registrateUser() {
        let successLogin = SuccessLoginScreenVC()
        self.view.endEditing(true)
        self.navigationController?.pushViewController(successLogin, animated: true)
    }

}

// MARK: - Check filling state

extension SignInVC: RegistrationViewDelegate {
    func userChangeFillState(isUserFillScreen: Bool) {
        enterButton.isButtonEnable = isUserFillScreen
    }
}

// MARK: - Check Keyboard

extension SignInVC: CheckKeyboardViewModelDelegate {
    func keyboardAction(action: KeyboardAction) {
        switch action {
        case .hideKeyboard:
            registrationButtonBottomConstraint.constant = 18
        case .showKeyboard(keyboardHeight: let height):
            registrationButtonBottomConstraint.constant = UIDevice.current.isSmallDevice ? height + 20 : height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
