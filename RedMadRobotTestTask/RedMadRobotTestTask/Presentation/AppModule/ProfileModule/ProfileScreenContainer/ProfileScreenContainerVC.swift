//
//  ProfileScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

/// Основной контейнер для экрана flow экранов пользовательской информации
final class ProfileScreenContainerVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentScrollView: UIScrollView!
    
    @IBOutlet private weak var userInfoContainerView: UIView!
    @IBOutlet private weak var profileInfoContainerView: UIView!
    @IBOutlet private weak var changeProfileCategoryContainerView: UIView!
    
    @IBOutlet private weak var userInfoContainerTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private let coordinator: ProfileModuleCoordinator
    private var userService: UserInfoService
    
    // Constants
    private var isFirstLayout = true
    private let topInset: CGFloat = 12.0
    
    lazy private var contentInset: CGFloat = {
        return navBarHeight - topInset
    }()
    
    // Childs
    
    /// Child Шапка с информацией о пользователе
    lazy private var profileInfoVC = ProfileInfoVC(subscriber: self)
    
    /// Child ответственный за изменение категории
    lazy private var changeProfileCategoryVC = ChangeProfileCategoryVC(subscriber: self)
    
    /// Child со списком всех постов пользователя
    lazy private var userPostsVC = UserPostsContainerVC()
    
    /// Child со списком любимых постов пользователя
    lazy private var favoritePostsVC = FavouritePostsContainerVC()
    
    /// Child со списком всех друзей пользователя
    lazy private var listOfFriendsVC = FriendsListContainerVC(delegate: self)
    
    // MARK: - Init
    
    init(
        userService: UserInfoService = ServiceLayer.shared.userInfoService,
        coordinator: ProfileModuleCoordinator
    ) {
        self.userService = userService
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstLayout == true else { return }
        setupScrollView()
        setChilds()
        isFirstLayout = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        setupViews()
        setupNavBar()
    }
    
    // MARK: - Private Methods
    
    /// Отслеживаем изменения offSet-a на всех экранах с таблицами, и с его помощью меняем положение шапки с информацией о пользователе
    private func setupViews() {
        userPostsVC.changeOffSet = { [weak self] inset in
            guard let self = self else { return }
            self.userInfoContainerTopConstraint.constant = -inset - self.contentInset
        }
        
        favoritePostsVC.changeOffSet = { [weak self] inset in
            guard let self = self else { return }
            self.userInfoContainerTopConstraint.constant = -inset - self.contentInset
        }
        
        listOfFriendsVC.changeOffSet = { [weak self] inset in
            guard let self = self else { return }
            self.userInfoContainerTopConstraint.constant = -inset - self.contentInset
        }
    }
    
    private func setupScrollView() {
        contentScrollView.backgroundColor = ColorPalette.mainBackgroundColor
        contentScrollView.contentInsetAdjustmentBehavior = .never
        contentScrollView.contentSize = CGSize(
            width: view.frame.width * 3,
            height: contentScrollView.safeAreaLayoutGuide.layoutFrame.height
        )
    }
    
    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(logoutAction)
        )
    }
    
    @objc private func logoutAction() {
        coordinator.logoutFromApp()
    }
    
    private func setChilds() {
        addChild(controller: profileInfoVC, rootView: profileInfoContainerView)
        addChild(controller: changeProfileCategoryVC, rootView: changeProfileCategoryContainerView)
        
        // Чайлды с постами добавлены на scrollView, благодаря этому получилось сделать красивую анимацию переходов
        
        userPostsVC.view.frame = contentScrollView.frame
        userPostsVC.view.frame.origin = CGPoint.zero
        
        favoritePostsVC.view.frame = contentScrollView.frame
        favoritePostsVC.view.frame.origin = CGPoint(x: view.frame.width, y: 0)
        
        listOfFriendsVC.view.frame = contentScrollView.frame
        listOfFriendsVC.view.frame.origin = CGPoint(x: view.frame.width * 2, y: 0)

        addChildControllerToScrollView(child: userPostsVC, scrollView: contentScrollView)
        addChildControllerToScrollView(child: favoritePostsVC, scrollView: contentScrollView)
        addChildControllerToScrollView(child: listOfFriendsVC, scrollView: contentScrollView)
        
        setupInsetsInChilds()
    }
    
    /// Передаем чайлдам размер шапки пользователя
    private func setupInsetsInChilds() {
        let userContainerHeight = topInset + userInfoContainerView.frame.height + 2
        
        userPostsVC.setTopInset(userContainerHeight)
        favoritePostsVC.setTopInset(userContainerHeight)
        listOfFriendsVC.setTopInset(userContainerHeight)

        view.bringSubviewToFront(userInfoContainerView)
    }
    
    /// Получаем информацию о пользователе
    private func getUserInfo() {
        _ = userService.getUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.profileInfoVC.setUserInfo(user)
                self.navigationItem.title = user.nickname == nil ? "Профиль" : "@\(user.nickname ?? "")"
            case .failure:
                break
            }
        }
    }

}

// MARK: - ChangeCategory Delegate

extension ProfileScreenContainerVC: ChangeProfileCategoryDelegate {
    
    /// Ставим нужный offSet для scrollView, для отображения нужного экрана
    /// - Parameter category: одна из категорий
    func changeCategory(_ category: ProfileCategories) {
        let xOffSet: CGFloat
        let width = view.frame.width
        
        switch category {
        case .posts:
            xOffSet = 0.0
            userPostsVC.updateLikes()
        case .favoritePosts:
            xOffSet = width
            favoritePostsVC.updateLikes()
        case .friends:
            xOffSet = width * 2
        }
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0.0,
            usingSpringWithDamping: 0.75,
            initialSpringVelocity: 2.5,
            options: .curveEaseInOut
        ) {
            self.contentScrollView.contentOffset = CGPoint(x: xOffSet, y: 0)
        }
    }
    
}

// MARK: - Profile screen delegate

extension ProfileScreenContainerVC: ProfileInfoDelegate {
    
    func editProfileAction() {
        print("edit button action")
    }
    
}

// MARK: - FriendsListContainerVCDelegate

extension ProfileScreenContainerVC: FriendsListContainerVCDelegate {
    
    func showFindFriendsScreen() {
        coordinator.pushSearchNewFriends()
    }
    
}
