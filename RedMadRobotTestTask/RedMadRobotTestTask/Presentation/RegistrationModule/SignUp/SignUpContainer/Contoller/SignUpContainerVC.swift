//
//  SignUpContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

final class SignUpContainerVC: UIViewController {
    
    // MARK: - Properties
    private let navBarViewModel: SignInViewModelProtocol?
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    private let uiViewModel = SignUpContainerViewModel()
    private let registrationService = RegistrationService.shared
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var registeredButton: UIButton!
    @IBOutlet private weak var nextButton: RegistrationNextButton!
    
    @IBOutlet private weak var progressViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    lazy private var signUpFirstScreen = SignUpFirstVC(subscriber: self)
    lazy private var signUpSecondScreen = SignUpSecondVC(subscriber: self)
    
    private var isFirstStart = true
    
    // MARK: - Init
    init(viewModel: SignInViewModelProtocol, checkKeyboardViewModel: CheckKeyboardViewModel) {
        self.navBarViewModel = viewModel
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: R.nib.signUpContainerVC.name, bundle: R.nib.signInVC.bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstStart == true else { return }
        isFirstStart = false
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBarSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Methods
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        navBarViewModel?.customizeNavBar(navigationBar: navigationController?.navigationBar,
                                         navigationItem: navigationItem,
                                         title: R.string.localizable.signUpNavBarTitle())
    }
    
    private func initialSetup() {
        nextButton.setState(isButtonEnabled: false)
        checkKeyboardViewModel.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupScrollView() {
        uiViewModel.setupScrollView(rootVC: self,
                                    signUpFirstScreen: signUpFirstScreen,
                                    signUpSecondScreen: signUpSecondScreen,
                                    scrollView: scrollView)
    }
    
    @IBAction private func isAlreadyRegisteredAction(_ sender: Any) {
        let signInVC = SignInVC(uiViewModel: SetupNavBarViewModel(),
                                checkKeyboardViewModel: CheckKeyboardViewModel(subscriber: nil))
        navigationController?.pushViewController(signInVC, animated: true)
    }
    
    @IBAction private func nextButtonAction(_ sender: Any) {
        guard nextButton.isButtonEnable == true else {
            switch uiViewModel.currentScreen {
            case .firstScreen:
                signUpFirstScreen.checkForWarnings()
            case .secondScreen:
                signUpSecondScreen.checkForWarnings()
            }
            return
        }
        
        guard uiViewModel.nextButtonAction(rootView: view,
                                           scrollView: scrollView,
                                           progressViewTrailingConstraint: progressViewTrailingConstraint,
                                           registeredButton: registeredButton,
                                           nextButton: nextButton) == true else { return }
        
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
                let successLogin = SuccessLoginScreenVC()
                self.view.endEditing(true)
                self.navigationController?.pushViewController(successLogin, animated: true)
            case .failure(_ ):
                break
            }
        }
    }
}

// MARK: - Check user state
extension SignUpContainerVC: RegistrationViewDelegate {
    func userChangeFillState(isUserFillScreen: Bool) {
        nextButton.setState(isButtonEnabled: isUserFillScreen)
    }
}

// MARK: - Sign In View Delegate
extension SignUpContainerVC: CheckKeyboardViewModelDelegate {
    // TODO: - Hide Registration button on small device
    func keyboardAction(action: AuthorizationTextField.KeyboardAction) {
        
        switch action {
        case .hideKeyboard:
            nextButtonBottomConstraint.constant = 8
        case .showKeyboard(keyboardHeight: let height):
            nextButtonBottomConstraint.constant = UIDevice().isSmallDevice ? height + 20 : height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
