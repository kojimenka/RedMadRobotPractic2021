//
//  MainPostScreenVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 29.05.2021.
//

import UIKit

class MainPostScreenVC: UIViewController {
    
    // MARK: - IBOutlets
    
    private var zeroScreenContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .orange
        return view
    }()
    
    private var zeroScreenTopConstraint = NSLayoutConstraint()
    
    // MARK: - Public Properties
    
    public var changeOffSet: ((CGFloat) -> Void)?
    
    // MARK: - Private Properties
    
    private var isFirstStart = true
    private var topInset: CGFloat = 0.0
    
    lazy public var userPostsVC = PostsFeedVC(
        subscriber: self
    )
    
    private let zeroScreen: ZeroScreenVC
    
    // MARK: - Init
    
    init(zeroScreen: ZeroScreenVC) {
        self.zeroScreen = zeroScreen
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChilds()
        setConstraints()
    }
    
    // MARK: - Public Methods
    
    public func setTopInset(_ inset: CGFloat) {
        zeroScreenTopConstraint.constant = inset + navBarHeight
        userPostsVC.setTopInset(inset)
    }
    
    public func setChilds() {
        addChild(controller: userPostsVC, rootView: view)
        addChild(controller: zeroScreen, rootView: zeroScreenContainer)
        
        userPostsVC.view.alpha = 0.0
        zeroScreen.view.alpha = 0.0
    }
    
    public func showZeroScreen() {
        userPostsVC.view.animateHide()
        zeroScreen.view.animateShow()
    }
    
    public func showPostsScreen() {
        userPostsVC.view.animateShow()
        zeroScreen.view.animateHide()
    }
    
    public func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) {}
    
    private func setConstraints() {
        view.addSubview(zeroScreenContainer)
        
        zeroScreenTopConstraint = zeroScreenContainer.topAnchor.constraint(equalTo: view.topAnchor)
        
        NSLayoutConstraint.activate([
            zeroScreenTopConstraint,
            zeroScreenContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zeroScreenContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zeroScreenContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        view.sendSubviewToBack(zeroScreenContainer)
    }
    
}

// MARK: - UserPostsDelegate

extension MainPostScreenVC {
    func scrollViewOffSetChanged(inset: CGFloat) {
        changeOffSet?(inset)
    }
}

// MARK: - AllPosts Delegate

extension MainPostScreenVC: PostsFeedDelegate {
    
    func likePostButtonAction(isLiked: Bool, id: String) {
        
    }
    
}
