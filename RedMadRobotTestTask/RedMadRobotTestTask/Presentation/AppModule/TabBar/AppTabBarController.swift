//
//  AppTabBarController.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol AppTabBarControllerDelegate: AnyObject {
    func logoutFromMain()
}

final class AppTabBarController: UITabBarController {
    
    // MARK: - Private Properties
    
    weak private var appTabBarDelegate: AppTabBarControllerDelegate?
    
    /// Если выбранный контроллер является addPostVC, то мы показываем экран с добавлением постов с помощью present,  а выбранным контроллером назначаем прошлый выбранный контроллер
    override var selectedViewController: UIViewController? {
        didSet {
            if selectedViewController === addPostVC {
                presentPostScreen()
                selectedViewController = oldValue
            }
        }
    }
    
    // Контроллеры
    
    /// Контроллер для добавления нового поста, используем болванку, так как настоящий экран с добавлением фото мы представляем с помощью Present
    private let addPostVC = UIViewController()
    
    /// Координатор с флоу новостной лентой
    private let feedCoordinator = FeedModuleCoordinator(
        navigationController: AppNavigationController()
    )
    
    /// Координатор с флоу пользовательским экраном
    lazy private var profileScreenCoordinator = ProfileModuleCoordinator(
        delegate: self,
        navigationController: AppNavigationController()
    )
    
    // MARK: - Init
    
    init(appTabBarDelegate: AppTabBarControllerDelegate?) {
        self.appTabBarDelegate = appTabBarDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTabBar()
        setController()
    }
    
    // MARK: - Public Methods
    
    /// Метод для представления экрана с постами, он объявлен как public, так как у одного Zero Screen-a есть экшен на создание поста
    public func presentPostScreen() {
        let createPostVC = CreatePostContainerVC()
        createPostVC.modalPresentationStyle = .fullScreen
        self.present(createPostVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func customizeTabBar() {
        tabBar.tintColor = ColorPalette.tintOrangeColor
    }
    
    private func setController() {
        feedCoordinator.start()
        profileScreenCoordinator.start()
        
        feedCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: R.image.feedTabBarIcon(),
            tag: 0
        )
        
        addPostVC.tabBarItem = UITabBarItem(
            title: "",
            image: R.image.newPostTabBarIcon(),
            tag: 1
        )
        
        profileScreenCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "",
            image: R.image.accountTabBarIcon(),
            tag: 2
        )
        
        viewControllers = [
            feedCoordinator.navigationController,
            addPostVC,
            profileScreenCoordinator.navigationController
        ]
    }
    
}

// MARK: - Profile Screen Delegate

extension AppTabBarController: ProfileModuleCoordinatorDelegate {
    
    func logoutFromMainModule() {
        appTabBarDelegate?.logoutFromMain()
    }
    
}
