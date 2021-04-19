//
//  SignInVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class SignInVC: UIViewController {

    // MARK: - Properties
    private let uiViewModel: SignInViewModelProtocol?
    private let checkKeyboardViewModel: CheckKeyboardViewModel
        
    @IBOutlet private weak var enterButton: RegistrationNextButton!
    @IBOutlet private weak var signInView: RegistrationView!
    @IBOutlet private weak var registrationButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    init(uiViewModel: SignInViewModelProtocol, checkKeyboardViewModel: CheckKeyboardViewModel) {
        self.uiViewModel = uiViewModel
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: R.nib.signInVC.name, bundle: R.nib.signInVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Methods
    @IBAction private func signUpButtonAction(_ sender: Any) {
        let signUpVC = SignUpContainerVC(viewModel: SetupNavBarViewModel(),
                                         checkKeyboardViewModel: CheckKeyboardViewModel(subscriber: nil))
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        guard enterButton.isButtonEnable == true else { signInView.checkForWarning(); return }
        let successLogicVC = SuccessLoginScreenVC()
        view.endEditing(true) // Dismiss keyboard
        navigationController?.pushViewController(successLogicVC, animated: true)
    }
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        uiViewModel?.customizeNavBar(navigationBar: navigationController?.navigationBar,
                                     navigationItem: navigationItem,
                                     title: R.string.localizable.signInNavBarTitle())
    }
    
    private func setupViews() {
        checkKeyboardViewModel.delegate = self
        signInView.delegate = self
        enterButton.setState(isButtonEnabled: false)
    }
    
}

// MARK: - Check user state
extension SignInVC: RegistrationViewDelegate {
    func userChangeFillState(isUserFillScreen: Bool) {
        enterButton.setState(isButtonEnabled: isUserFillScreen)
    }
}

// MARK: - Check Keyboard
extension SignInVC: CheckKeyboardViewModelDelegate {
    func keyboardAction(action: AuthorizationTextField.KeyboardAction) {
        switch action {
        case .hideKeyboard:
            registrationButtonBottomConstraint.constant = 18
        case .showKeyboard(keyboardHeight: let height):
            registrationButtonBottomConstraint.constant = UIDevice().isSmallDevice ? height + 20 : height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
