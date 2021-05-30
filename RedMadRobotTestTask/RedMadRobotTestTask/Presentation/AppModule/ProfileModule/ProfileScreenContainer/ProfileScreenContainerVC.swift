//
//  ProfileScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol ProfileScreenOutputDelegate: AnyObject {
    
}

final class ProfileScreenContainerVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentScrollView: UIScrollView!
    
    @IBOutlet private weak var userInfoContainerView: UIView!
    @IBOutlet private weak var profileInfoContainerView: UIView!
    @IBOutlet private weak var changeProfileCategoryContainerView: UIView!
    
    @IBOutlet private weak var userInfoContainerTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    weak private var outputDelegate: ProfileScreenOutputDelegate?
    private var userService: UserInfoServiceProtocol
    
    // Constants
    private var isFirstStart = true
    private let topInset: CGFloat = 12.0
    
    lazy private var contentInset: CGFloat = {
        return navBarHeight - topInset
    }()
    
    // Childs
    lazy private var profileInfoVC = ProfileInfoVC(subscriber: self)
    lazy private var changeProfileCategoryVC = ChangeProfileCategoryVC(subscriber: self)
    
    lazy private var userPostsVC = UserPostsContainerVC()
    lazy private var favoritePostsVC = FavouritePostsContainerVC()
    
    // MARK: - Initializers
    
    init(
        userService: UserInfoServiceProtocol = ServiceLayer.shared.userInfoService,
        outputSubscriber: ProfileScreenOutputDelegate?
    ) {
        self.userService = userService
        self.outputDelegate = outputSubscriber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard isFirstStart == true else { return }
        setupScrollView()
        setChilds()
        isFirstStart = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfo()
        setupViews()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        userPostsVC.changeOffSet = { [weak self] inset in
            guard let self = self else { return }
            self.userInfoContainerTopConstraint.constant = -inset - self.contentInset
        }
        
        favoritePostsVC.changeOffSet = { [weak self] inset in
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
    
    private func setChilds() {
        addChild(controller: profileInfoVC, rootView: profileInfoContainerView)
        addChild(controller: changeProfileCategoryVC, rootView: changeProfileCategoryContainerView)
        
        // Чайлды с постами добавлены на scrollView, благодаря этому получилось сделать красивую анимацию переходов
        
        userPostsVC.view.frame = contentScrollView.frame
        userPostsVC.view.frame.origin = CGPoint.zero
        
        favoritePostsVC.view.frame = contentScrollView.frame
        favoritePostsVC.view.frame.origin = CGPoint(x: view.frame.width, y: 0)

        addChildControllerToScrollView(child: userPostsVC, scrollView: contentScrollView)
        addChildControllerToScrollView(child: favoritePostsVC, scrollView: contentScrollView)
        
        setupInsetsInChilds()
    }
    
    private func setupInsetsInChilds() {
        let userContainerHeight = topInset + userInfoContainerView.frame.height + 2
        
        userPostsVC.setTopInset(userContainerHeight)
        favoritePostsVC.setTopInset(userContainerHeight)

        view.bringSubviewToFront(userInfoContainerView)
    }
    
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
    func changeCategory(_ category: ProfileCategories) {
        let xOffSet: CGFloat
        let width = view.frame.width
        
        switch category {
        case .posts:
            xOffSet = 0.0
        case .favoritePosts:
            xOffSet = width
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
