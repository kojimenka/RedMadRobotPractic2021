//
//  AppViewController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import UIKit

/// Рутовый ViewController который руководит изменениям сценариев для пользователя
final class AppViewController: UIViewController {
    
    // MARK: - Private Properties
    
    // --- Services
    
    private let keychainManager: KeychainManager
    private var dataInRamManager: DataInRamManager
    
    // --- Childs
    
    lazy private var registrationContainerVC = RegistrationContainerVC(delegate: self)
    lazy private var lockScreen = LockScreenVC(currentState: .lockInMainApp, delegate: self)
    lazy private var appTabBarController = AppTabBarController(appTabBarDelegate: self)

    // MARK: - Init
    
    init(
        dataInRamManager: DataInRamManager = ServiceLayer.shared.dataInRamManager,
        keychainManager: KeychainManager = ServiceLayer.shared.keychainManager
    ) {
        self.keychainManager = keychainManager
        self.dataInRamManager = dataInRamManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialController()
    }
    
    // MARK: - Private Methods
    
    /// Метод для установки нужного экрана, если токен не существует, показываем экран авторизации. Если токен есть, показываем экран с пин кодом
    private func setInitialController() {
        if keychainManager.isEntryExist(key: .refreshToken) {
            addChild(controller: lockScreen, rootView: view)
        } else {
            addChild(controller: registrationContainerVC, rootView: view)
        }
    }
    
    /// После выхода из профиля, нужно удалить все данные о пользователе
    private func deleteAllUserData() {
        try? keychainManager.deleteEntry(key: .password)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            try? self.keychainManager.deleteEntry(key: .refreshToken)
        }
        
        dataInRamManager.accessToken = nil
        dataInRamManager.password = nil
    }
    
}

// MARK: - RegistrationFlow Delegate

extension AppViewController: RegistrationContainerVCDelegate {
    
    func endRegistrationFlow() {
        changeChildWithAnimation(newChild: appTabBarController)
    }

}

// MARK: - LockScreen Delegate

extension AppViewController: LockScreenDelegate {
    
    func logoutAction() {
        deleteAllUserData()
        changeChildWithAnimation(newChild: registrationContainerVC)
    }
    
    func successAuthentification() {
        self.changeChildWithAnimation(newChild: appTabBarController)
    }
    
}

// MARK: - AppTabBar Delegate

extension AppViewController: AppTabBarControllerDelegate {
    
    func logoutFromMain() {
        deleteAllUserData()
        appTabBarController = AppTabBarController(appTabBarDelegate: self)
        changeChildWithAnimation(newChild: registrationContainerVC)
    }
    
}
