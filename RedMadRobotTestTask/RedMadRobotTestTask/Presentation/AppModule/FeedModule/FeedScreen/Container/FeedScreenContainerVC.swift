//
//  FeedScreenContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

final class FeedScreenContainerVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var contentView: UIView!
    
    // MARK: - Private Properties
    
    weak private var coordinator: FeedModuleCoordinator?
    private let navBarViewModel: SetupNavBarViewModelProtocol
    private let feedService: FeedServiceProtocol

    // Childs
    
    lazy private var feedScreenVC = FeedScreenVC(subscriber: self, allPostsVC: allPostsVC)
    lazy private var allPostsVC = PostsFeedVC(
        subscriber: self,
        requestViewModel: AllPostsRequestViewModel(feedService: ServiceLayer.shared.feedService)
    )
    
    // MARK: - Init
    
    init(
        coordinator: FeedModuleCoordinator?,
        feedService: FeedServiceProtocol = ServiceLayer.shared.feedService,
        navBarViewModel: SetupNavBarViewModelProtocol = SetupNavBarViewModel()
    ) {
        self.navBarViewModel = navBarViewModel
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
        setupFeedScreen()
        navBarSetup()
    }
    
    // MARK: - Public Methods
    
    public func updatePosts() {
        allPostsVC.requestData { [weak self] res in
            guard let self = self else { return }
            if res {
                self.setupFeedScreen()
            }
        }
    }

    // MARK: - Private Methods
    
    private func navBarSetup() {
        navigationController?.navigationBar.isHidden = false
        navBarViewModel.customizeNavBar(
            navigationBar: navigationController?.navigationBar,
            navigationItem: navigationItem,
            title: ""
        )
    }
    
    private func setupFeedScreen() {
        removeAllSubviewsFromContentView()
        addChild(controller: feedScreenVC, rootView: contentView)
    }
    
    // Временное решение, в будущем сделать через AnimationTransition
    private func removeAllSubviewsFromContentView() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

}

// MARK: - Feed Screen Delegate

extension FeedScreenContainerVC: FeedScreeDelegate {
  
}

// MARK: - All Posts Delegate

extension FeedScreenContainerVC: PostsFeedDelegate {
    func emptyPosts() {
        removeAllSubviewsFromContentView()
        let zeroScreen = ZeroScreenVC(screenState: .feedScreen) { [weak self] in
            guard let self = self else { return }
            self.coordinator?.showSearchFriendScreen()
        }
        addChild(controller: zeroScreen, rootView: contentView)
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
    
    func failureRequest() {
        removeAllSubviewsFromContentView()
        let zeroScreen = ZeroScreenVC(screenState: .feedScreen) { [weak self] in
            guard let self = self else { return }
            self.allPostsVC.requestData { [weak self] res in
                guard let self = self else { return }
                if res {
                    self.setupFeedScreen()
                }
            }
        }
        addChild(controller: zeroScreen, rootView: contentView)
    }
}
