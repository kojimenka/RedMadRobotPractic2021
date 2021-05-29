//
//  FeedScreenContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

final class FeedScreenContainerVC: UIViewController {

    // MARK: - Private Properties
    
    weak private var coordinator: FeedModuleCoordinator?
    private let feedService: FeedServiceProtocol
    private let zeroScreenFabric = ZeroScreenFabric()

    // Childs

    lazy private var allPostsVC = PostsFeedVC(subscriber: self)
    
    // MARK: - Init
    
    init(
        coordinator: FeedModuleCoordinator?,
        feedService: FeedServiceProtocol = ServiceLayer.shared.feedService
    ) {
        self.coordinator = coordinator
        self.feedService = feedService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allPostsVC.requestData()
        setupView()
        navBarSetup()
    }
    
    // MARK: - Public Methods
    
    public func updatePosts() {
        allPostsVC.requestData()
    }

    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = ColorPalette.mainBackgroundColor
    }
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setNewChild(child: UIViewController) {
        UIView.AnimationTransition.removeAllSubviews(rootView: view)
        addChild(controller: child, rootView: view)
    }
    
    private func showFeedScreen() {
        setNewChild(child: allPostsVC)
    }
    
    private func showEmptyPostZeroScreen() {
        let zeroScreen = zeroScreenFabric.createZeroModel(state: .feedScreen) { [weak self] in
            guard let self = self else { return }
            self.coordinator?.showSearchFriendScreen()
        }
        
        setNewChild(child: zeroScreen)
    }
    
    private func showErrorZeroScreen() {
        let zeroScreen = zeroScreenFabric.createZeroModel(state: .genericError) { [weak self] in
            guard let self = self else { return }
            self.allPostsVC.requestData()
        }
        setNewChild(child: zeroScreen)
    }

}

// MARK: - All Posts Delegate

extension FeedScreenContainerVC: PostsFeedDelegate {
    
    func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) {
        _ = feedService.getFeed { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                if content.isEmpty {
                    completion(.failure(LoginValidatorError.emptyLogin))
                    self.showEmptyPostZeroScreen()
                } else {
                    self.getLikedPosts(
                        feedPosts: content,
                        completion: completion
                    )
                }
            case .failure:
                completion(result)
                self.showErrorZeroScreen()
            }
        }
    }
    
    func getLikedPosts(
        feedPosts: [PostInfo],
        completion: @escaping (Result<[PostInfo], Error>) -> Void
    ) {
        _ = feedService.getFavouritePosts(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let likedPosts):
                var mutableFeedPost = feedPosts
                // Отмечаем во всех постах, посты которые пользователь лайкнул 
                for (index, feedPost) in mutableFeedPost.enumerated() {
                    mutableFeedPost[index].isLikedPost = likedPosts.contains(feedPost)
                }
                completion(.success(mutableFeedPost))
                self.showFeedScreen()
            case .failure(let error):
                completion(.failure(error))
                self.showErrorZeroScreen()
            }
        })
    }
    
    func likePostButtonAction(isLiked: Bool, id: String) {
        if isLiked {
            likePost(id: id)
        } else {
            unlikePost(id: id)
        }
    }
    
    func likePost(id: String) {
        _ = feedService.addLikeToPost(postID: id) { result in
            switch result {
            case .success:
                print("DEBUG: Success add like")
            case .failure(let error):
                print("DEBUG: Failure add like with error  \(error.localizedDescription)")
            }
        }
    }
    
    func unlikePost(id: String) {
        _ = feedService.removeLikeFromPost(postID: id) { result in
            switch result {
            case .success:
                print("DEBUG: Success remove like")
            case .failure(let error):
                print("DEBUG: Failure remove like with error  \(error.localizedDescription)")
            }
        }
    }
    
}
