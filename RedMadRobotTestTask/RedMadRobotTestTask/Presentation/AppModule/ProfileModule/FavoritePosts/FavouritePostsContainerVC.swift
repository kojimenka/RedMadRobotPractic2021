//
//  FavouritePostsContainerVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 29.05.2021.
//

import UIKit

/// Экран отображающий список любимых постов
final class FavouritePostsContainerVC: MainPostScreenVC {
    
    private let zeroScreen = ZeroScreenFabric().createZeroModel(state: .userFavoritePosts)
    private let feedService: FeedService
    
    // MARK: - Init
    
    init(
        feedService: FeedService = ServiceLayer.shared.feedService
    ) {
        self.feedService = feedService
        super.init(zeroScreen: zeroScreen)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLikes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupZeroScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.userPostsVC.requestData()
    }
    
    // MARK: - Public Methods
    
    override func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) {
        _ = feedService.getFavouritePosts(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let content):
                if content.isEmpty {
                    completion(.failure(LoginValidatorError.emptyLogin))
                    self.showZeroScreen()
                } else {
                    self.showPostsScreen()
                    completion(.success(content))
                }
            case .failure:
                completion(result)
                self.showZeroScreen()
            }
        })
    }
    
    public func updateLikes() {
        if updateManager.isUpdateFavoritePostsNeeded {
            super.userPostsVC.requestData()
            updateManager.isUpdateFavoritePostsNeeded = false
        }
    }
    
    // MARK: - Private Methods
    
    private func setupZeroScreen() {
        zeroScreen.buttonAction = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.tabBarController?.selectedIndex = 0
        }
    }

}
