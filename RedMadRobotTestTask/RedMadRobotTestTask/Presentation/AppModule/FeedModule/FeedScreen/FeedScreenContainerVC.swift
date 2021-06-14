//
//  FeedScreenContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import UIKit

/// Контейнер для флоу экранов всех постов.
final class FeedScreenContainerVC: UIViewController {

    // MARK: - Private Properties
    
    weak private var coordinator: FeedModuleCoordinator?
    private let zeroScreenFabric = ZeroScreenFabric()
    private let feedService: FeedService
    
    /// Менеджер хранящий данные, каким экраном нужно обновить данные
    private var updateManager: UpdateManager
    
    /// Менеджер который содержит текущие любимые посты
    private let favoritePostsManager: FavouritePostsManager
    
    // Childs

    lazy private var allPostsVC = PostsFeedVC(subscriber: self)
    
    // MARK: - Init
    
    init(
        coordinator: FeedModuleCoordinator?,
        feedService: FeedService = ServiceLayer.shared.feedService,
        updateManager: UpdateManager = ServiceLayer.shared.updateManager,
        favoritePostsManager: FavouritePostsManager = ServiceLayer.shared.favouritePostsManager
    ) {
        self.favoritePostsManager = favoritePostsManager
        self.coordinator = coordinator
        self.feedService = feedService
        self.updateManager = updateManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    /// Если менеджер сообщает об обновлениях, делаем запрос на новые данные.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if updateManager.isUpdateFeedNeeded {
            updatePosts()
            updateManager.isUpdateFeedNeeded = false
        }
    }
    
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
        allPostsVC.setTopInset(12.0)
    }
    
    private func navBarSetup() {
        self.navigationItem.title = "Популярное"
    }
    
    private func setNewChild(child: UIViewController) {
        UIView.AnimationTransition.removeAllSubviews(rootView: view)
        addChild(controller: child, rootView: view)
    }
    
    private func showFeedScreen() {
        setNewChild(child: allPostsVC)
    }
    
    /// Zero screen если у пользователя нет постов
    private func showEmptyPostZeroScreen() {
        let zeroScreen = zeroScreenFabric.createZeroModel(state: .feedScreen) { [weak self] in
            guard let self = self else { return }
            self.coordinator?.showSearchFriendScreen()
        }
        
        setNewChild(child: zeroScreen)
    }
    
    /// Zero screen для отображения сетевой ошибки
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
                    completion(.failure(NetworkErrors.genericError))
                    self.showEmptyPostZeroScreen()
                } else {
                    self.favoritePostsManager.getFavouritePosts { [weak self] in
                        guard let self = self else { return }
                        completion(.success(content))
                        self.showFeedScreen()
                    }
                }
            case .failure:
                completion(result)
                self.showErrorZeroScreen()
            }
        }
    }
    
    func scrollViewOffSetChanged(inset: CGFloat) {}
    
}
