//
//  FavoritePostsVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.05.2021.
//

import UIKit

protocol FavoritePostsDelegate: PostsFeedInProfileDelegate {
    func addLikeToPost(id: String)
}

final class FavoritePostsVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var favoritePostsContainerView: UIView!
    
    // MARK: - Private Properties
    
    weak private var delegate: FavoritePostsDelegate?
    
//    private let zeroScreen = ZeroScreenView(screenState: .userFavoritePosts)
    
    lazy private var allPostsVC = PostsFeedVC(
        profileSubscriber: delegate,
        subscriber: self
    )
    
    // MARK: - Init
    
    init(subscriber: FavoritePostsDelegate?) {
        self.delegate = subscriber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChilds()
        setupZeroScreen()
    }
    
    // MARK: - Public Methods
    
    public func setTopInsetInPostCollection(_ inset: CGFloat) {
        allPostsVC.setTopInset(inset)
    }

    // MARK: - Private Methods
    
    private func setChilds() {
        addChild(controller: allPostsVC, rootView: favoritePostsContainerView)
    }
    
    private func setupZeroScreen() {
//        zeroScreen.buttonAction = { [weak self] in
//            guard let self = self else { return }
//            self.allPostsVC.updateData()
//        }
    }
    
}

// MARK: - Favorite Posts Delegate

extension FavoritePostsVC: PostsFeedDelegate {
    func likePostButtonAction(isLiked: Bool, id: String) {
        
    }
    
    func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) {
        
    }
}
