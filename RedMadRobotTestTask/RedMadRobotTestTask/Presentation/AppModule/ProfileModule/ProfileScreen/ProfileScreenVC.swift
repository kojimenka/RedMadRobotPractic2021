//
//  ProfileScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.04.2021.
//

import UIKit

protocol ProfileScreenOutputDelegate: AnyObject {
    
}

final class ProfileScreenVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentScrollView: UIScrollView!
    
    @IBOutlet private weak var userInfoContainerView: UIView!
    @IBOutlet private weak var profileInfoContainerView: UIView!
    @IBOutlet private weak var changeProfileCategoryContainerView: UIView!
    
    @IBOutlet private weak var userInfoContainerTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var isFirstStart = true
    
    weak private var outputDelegate: ProfileScreenOutputDelegate?
    
    // Childs
    lazy private var profileInfoVC = ProfileInfoVC(subscriber: self)
    lazy private var changeProfileCategoryVC = ChangeProfileCategoryVC(subscriber: self)
    
    private let allPostsVC = PostsFeedVC(state: .userPosts)
    private let favoritePostsVC = PostsFeedVC(state: .userFavoritePosts)
    
    // MARK: - Initializers
    
    init(outputSubscriber: ProfileScreenOutputDelegate?) {
        self.outputDelegate = outputSubscriber
        super.init(nibName: R.nib.profileScreenVC.name, bundle: R.nib.profileScreenVC.bundle)
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
        setupViews()
        isFirstStart = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        navigationController?.navigationBar.isHidden = true
    
        // Отслеживаем изменения оффсета в коллекциях для изменений констрейнта в чайлде с информацией о пользователе
        
        allPostsVC.scrollViewOffSetChanged = { [weak self] offSet in
            guard let self = self else { return }
            self.userInfoContainerTopConstraint.constant = -offSet
        }
        
        favoritePostsVC.scrollViewOffSetChanged = { [weak self] offSet in
            guard let self = self else { return }
            self.userInfoContainerTopConstraint.constant = -offSet
        }
    }
    
    private func setupScrollView() {
        contentScrollView.contentInsetAdjustmentBehavior = .never
        
        contentScrollView.backgroundColor = ColorPalette.mainBackgroundColor
                
        contentScrollView.contentSize = CGSize(
            width: view.frame.width * 3,
            height: contentScrollView.safeAreaLayoutGuide.layoutFrame.height
        )
    }
    
    private func setChilds() {
        addChild(controller: profileInfoVC, rootView: profileInfoContainerView)
        addChild(controller: changeProfileCategoryVC, rootView: changeProfileCategoryContainerView)
        
        // Чайлды с постами добавлены на scrollView, благодаря этому получилось сделать красивую анимацию переходов
        
        allPostsVC.view.frame = contentScrollView.frame
        allPostsVC.view.frame.origin = CGPoint.zero
        
        favoritePostsVC.view.frame = contentScrollView.frame
        favoritePostsVC.view.frame.origin = CGPoint(x: view.frame.width, y: 0)
        
        addChildControllerToScrollView(child: allPostsVC, scrollView: contentScrollView)
        addChildControllerToScrollView(child: favoritePostsVC, scrollView: contentScrollView)
        
        setupInsetsInChilds()
    }
    
    private func setupInsetsInChilds() {
        let topSafeAreaInset = UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 0.0
        let fullInset = topSafeAreaInset + userInfoContainerView.frame.height + 2
        
        allPostsVC.setTopInset(fullInset)
        favoritePostsVC.setTopInset(fullInset)
        
        view.bringSubviewToFront(userInfoContainerView)
    }

}

// MARK: - ChangeCategory Delegate

extension ProfileScreenVC: ChangeProfileCategoryDelegate {
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

extension ProfileScreenVC: ProfileInfoDelegate {
    func editProfileAction() {
        print("edit button action")
    }
}
