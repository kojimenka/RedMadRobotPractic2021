//
//  AppViewController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 06.06.2021.
//

import UIKit

final class AppViewController: UIViewController {
    
    // MARK: - Private Properties
    
    // --- Services
    
    private let keychainManager: KeychainManager
    private var dataInRamManager: DataInRamManager
    private let favoritePostsManager: FavouritePostsManager
    
    // --- Childs
    
    lazy private var registrationContainerVC = RegistrationContainerVC(delegate: self)
    lazy private var appTabBarController = AppTabBarController(appTabBarDelegate: self)
    
    lazy private var lockScreen = LockScreenVC(currentState: .lockInMainApp, delegate: self)

    // MARK: - Init
    
    init(
        dataInRamManager: DataInRamManager = ServiceLayer.shared.dataInRamManager,
        keychainManager: KeychainManager = ServiceLayer.shared.keychainManager,
        favoritePostsManager: FavouritePostsManager = ServiceLayer.shared.favouritePostsManager
    ) {
        self.favoritePostsManager = favoritePostsManager
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
    
    private func setInitialController() {
        if keychainManager.isEntryExist(key: .refreshToken) {
            addChild(controller: lockScreen, rootView: view)
        } else {
            addChild(controller: registrationContainerVC, rootView: view)
        }
    }
    
    private func showRegistrationFlow() {
        addChild(controller: registrationContainerVC, rootView: view)
    }
    
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
        self.favoritePostsManager.getFavouritePosts()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.favoritePostsManager.getFavouritePosts()
        }
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
