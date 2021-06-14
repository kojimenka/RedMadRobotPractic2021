//
//  SignUpContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

public protocol SignUpContainerDelegate: AnyObject {
    func signInButtonActionFromSignUp()
    func registrateUser(credentials: Credentials)
    func addUserInfo(_ userInfo: AddUserInformationModel)
}

/// Контейнер для регистрации пользователей. Внутри этого экрана есть два чайлда. Первый чайлд ответственен за регистрацию, второй за добавления дополнительной информации о пользователе.
final class SignUpContainerVC: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var registeredButton: UIButton!
    @IBOutlet private weak var nextButton: RegistrationNextButton!
    
    /// Констрейнт который меняет текущий прогресс регистарации
    @IBOutlet private weak var progressViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    weak private var delegate: SignUpContainerDelegate?
    
    /// ViewModel для отслеживания клавиатуры
    private let checkKeyboardViewModel: CheckKeyboardViewModel
    
    private let dataInRamManager: DataInRamManager
    
    // Childs Controllers
    lazy private var signUpFirstScreen = SignUpFirstVC(subscriber: self)
    lazy private var signUpSecondScreen = SignUpSecondVC(subscriber: self)
    
    private var isFirstLayout = true
    
    private var userCredentials = Credentials()
    private var userInfo = AddUserInformationModel()
    
    enum ScreenState {
        case firstScreen
        case secondScreen
    }
    
    public var currentScreen = ScreenState.firstScreen
    
    // MARK: - Initializers
    
    init(
        subscriber: SignUpContainerDelegate?,
        checkKeyboardViewModel: CheckKeyboardViewModel = CheckKeyboardViewModel(),
        dataInRamManager: DataInRamManager = ServiceLayer.shared.dataInRamManager
    ) {
        self.delegate = subscriber
        self.checkKeyboardViewModel = checkKeyboardViewModel
        self.dataInRamManager = dataInRamManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController(
    
    /// Как можно раньше узнаем размеры экрана и настраиваем scrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstLayout == true else { return }
        isFirstLayout = false
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
        /// Проверяем на ошибки заполнения данных
        guard nextButton.isButtonEnable == true else {
            switch currentScreen {
            case .firstScreen:
                signUpFirstScreen.checkForWarnings()
            case .secondScreen:
                signUpSecondScreen.checkForWarnings()
            }
            return
        }
        
        /// После успешного заполнения экрана, передаем контейнеру нужные данные, контейнер делает запрос и дальше уже решает что нужно делать
        switch currentScreen {
        case .firstScreen:
            delegate?.registrateUser(credentials: userCredentials)
        case .secondScreen:
            delegate?.addUserInfo(userInfo)
        }
    }
    
    // MARK: - Public Methods
    
    /// Показываем экран в добавлением пользовательской информации
    public func showSecondScreen() {
        let width = view.frame.width
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: true)
        progressViewTrailingConstraint.constant = -width
        
        UIView.AnimationTransition.transitionChangeButtonTitle(
            button: nextButton,
            title: R.string.localizable.signUpRegistrationButton()
        )
        
        UIView.animate(withDuration: 0.3) {
            self.registeredButton.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.registeredButton.isHidden = true
        }
        
        nextButton.isButtonEnable = false
        currentScreen = .secondScreen
    }
    
    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        title = R.string.localizable.signUpNavBarTitle()
    }
    
    private func initialSetup() {
        nextButton.isButtonEnable = false
        checkKeyboardViewModel.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    private func setupScrollView() {
        let width = view.frame.width
        
        scrollView.contentSize = CGSize(width: width * 2, height: scrollView.frame.height)
        
        signUpFirstScreen.view.frame = scrollView.frame
        signUpFirstScreen.view.frame.origin = CGPoint.zero
        
        signUpSecondScreen.view.frame = scrollView.frame
        signUpSecondScreen.view.frame.origin = CGPoint(x: width, y: 0)
        
        addChildControllerToScrollView(child: signUpFirstScreen, scrollView: scrollView)
        addChildControllerToScrollView(child: signUpSecondScreen, scrollView: scrollView)
    }
    
    private func registrateUser() {
        delegate?.registrateUser(credentials: userCredentials)
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
    
    /// Если пользователь успешно ввел все поля регистрации, то мы сохраняем эти данные здесь для совершения регистрации
    /// - Parameter userCredentials: Данные необходимые для регистрации
    func successFill(userCredentials: Credentials) {
        self.userCredentials = userCredentials
    }
    
    /// В зависимости от статуса заполнения данных, меняем статус кнопки
    func currentStatus(isUserFillScreen: Bool) {
        nextButton.isButtonEnable = isUserFillScreen
    }
    
}

// MARK: - Sign up second screen delegate

extension SignUpContainerVC: SignUpSecondScreenDelegate {
    
    /// Если пользователь успешно ввел все поля данных, то мы сохраняем эти данные здесь для совершения запроса на сервер
    func fullUserData(userModel: AddUserInformationModel) {
        self.userInfo = userModel
    }
    
}
