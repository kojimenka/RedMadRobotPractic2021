//
//  SignUpContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol SignUpContainerDelegate: AnyObject {
    func signInButtonActionFromSignUp()
    func registrateUser(credentials: Credentials, userInfo: UserInformation)
}

final class SignUpContainerVC: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var registeredButton: UIButton!
    @IBOutlet private weak var nextButton: RegistrationNextButton!
    
    @IBOutlet private weak var progressViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private let navBarViewModel: SetupNavBarViewModelProtocol?
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    private let viewViewModel = SignUpContainerViewModel()
    
    weak private var delegate: SignUpContainerDelegate?
    
    lazy private var signUpFirstScreen = SignUpFirstVC(subscriber: self)
    lazy private var signUpSecondScreen = SignUpSecondVC(subscriber: self)
    
    private var isFirstStart = true
    
    private var userInfo = UserInformation()
    private var userCredentials = Credentials()
    
    // MARK: - Initializers
    
    init(
        subscriber: SignUpContainerDelegate?,
        viewModel: SetupNavBarViewModelProtocol = SetupNavBarViewModel(),
        checkKeyboardViewModel: CheckKeyboardViewModel = CheckKeyboardViewModel(subscriber: nil)
    ) {
        self.delegate = subscriber
        self.navBarViewModel = viewModel
        self.checkKeyboardViewModel = checkKeyboardViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(
    
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
    
    // MARK: - IBOutlet
    
    @IBAction private func isAlreadyRegisteredAction(_ sender: Any) {
        delegate?.signInButtonActionFromSignUp()
    }
    
    @IBAction private func nextButtonAction(_ sender: Any) {
        guard nextButton.isButtonEnable == true else {
            switch viewViewModel.currentScreen {
            case .firstScreen:
                signUpFirstScreen.checkForWarnings()
            case .secondScreen:
                signUpSecondScreen.checkForWarnings()
            }
            return
        }
        
        // True - Second Screen, False - First Screen
        guard viewViewModel.nextButtonAction(
                rootView: view,
                scrollView: scrollView,
                progressViewTrailingConstraint: progressViewTrailingConstraint,
                registeredButton: registeredButton,
                nextButton: nextButton) == true else { return }
        
        registrateUser()
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        navBarViewModel?.customizeNavBar(
            navigationBar: navigationController?.navigationBar,
            navigationItem: navigationItem,
            title: R.string.localizable.signUpNavBarTitle()
        )
    }
    
    private func initialSetup() {
        nextButton.isButtonEnable = false
        checkKeyboardViewModel.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupScrollView() {
        viewViewModel.setupScrollView(
            rootVC: self,
            signUpFirstScreen: signUpFirstScreen,
            signUpSecondScreen: signUpSecondScreen,
            scrollView: scrollView
        )
    }
    
    private func registrateUser() {
        delegate?.registrateUser(
            credentials: userCredentials,
            userInfo: userInfo
        )
    }
}

// MARK: - Sign In View Delegate

extension SignUpContainerVC: CheckKeyboardViewModelDelegate {
    func keyboardAction(action: KeyboardAction) {
        switch action {
        case .hideKeyboard:
            nextButtonBottomConstraint.constant = 8
        case .showKeyboard(keyboardHeight: let height):
            nextButtonBottomConstraint.constant = UIDevice.current.isSmallDevice ? height + 20 : height
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Sign in first screen delegate

extension SignUpContainerVC: SignUpFirstScreenDelegate {
    func successFill(userCredentials: Credentials) {
        self.userCredentials = userCredentials
    }
    
    func currentStatus(isUserFillScreen: Bool) {
        nextButton.isButtonEnable = isUserFillScreen
    }
}

// MARK: - Sign up second screen delegate

extension SignUpContainerVC: SignUpSecondScreenDelegate {
 
}
