//
//  SignInVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol SignInDelegate: AnyObject {
    func signUpButtonActionFromSignIn()
    func successSignIn()
}

final class SignInVC: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var enterButton: RegistrationNextButton!
    @IBOutlet private weak var signInView: RegistrationView!
    @IBOutlet private weak var registrationButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignInDelegate?
    private let requestViewModel: SignInRequestViewModelProtocol
    private let uiViewModel: SetupNavBarViewModelProtocol?
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    
    // MARK: - Initializers
    
    init(
        requestViewModel: SignInRequestViewModelProtocol = SignInRequestViewModel(),
        subscriber: SignInDelegate?,
        uiViewModel: SetupNavBarViewModelProtocol = SetupNavBarViewModel(),
        checkKeyboardViewModel: CheckKeyboardViewModel = CheckKeyboardViewModel(subscriber: nil)
    ) {
        self.requestViewModel = requestViewModel
        self.delegate = subscriber
        self.uiViewModel = uiViewModel
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: nil, bundle: nil)
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
        delegate?.signUpButtonActionFromSignIn()
    }
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        guard enterButton.isButtonEnable == true else { signInView.checkForWarning(controller: self); return }
        registrateUser()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        uiViewModel?.customizeNavBar(
            navigationBar: navigationController?.navigationBar,
            navigationItem: navigationItem,
            title: R.string.localizable.signInNavBarTitle()
        )
    }
    
    private func setupViews() {
        checkKeyboardViewModel.delegate = self
        signInView.delegate = self
        enterButton.isButtonEnable = false
        self.hideKeyboardWhenTappedAround()
    }
    
    private func registrateUser() {
        self.view.endEditing(true)
        requestViewModel.registrateUser(
            email: "test",
            password: "test"
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.successSignIn()
            case .failure:
                break
            }
        }
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
