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
    private let registrationService = RegistrationService.shared
        
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
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction private func signUpButtonAction(_ sender: Any) {
        let signUpVC = SignUpContainerVC(viewModel: SetupNavBarViewModel(),
                                         checkKeyboardViewModel: CheckKeyboardViewModel(subscriber: nil))
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction private func enterButtonAction(_ sender: Any) {
        guard enterButton.isButtonEnable == true else { signInView.checkForWarning(); return }
        registrateUser()
    }
    
    private func registrateUser() {
        view.endEditing(true)
        let loaderView = RegistrationLoaderView()
        view.addSubview(loaderView)
        loaderView.startLoading(with: view)
        
        registrationService.registrateUser(user: MockData.shared.testUser) { [weak self] res in
            guard let self = self else { return }
            loaderView.endLoading()
            switch res {
            case .success(_ ):
                let successLogicVC = SuccessLoginScreenVC()
                self.view.endEditing(true) // Dismiss keyboard
                self.navigationController?.pushViewController(successLogicVC, animated: true)
            case .failure(_ ):
                break
            }
        }
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
