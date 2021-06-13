//
//  FavouritePostsManager.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 13.06.2021.
//

import Foundation

protocol FavouritePostsManager {
    var allPosts: [PostInfo] { get set }
    func removeLikeFromPost(id: String)
    func addLikedPost(post: PostInfo)
    func getFavouritePosts()
}

/// Класс ответственный за хранение лайкнутых пользователем постов 
final class FavouritePostsManagerImpl: FavouritePostsManager {
    
    // MARK: - Public Properties

    public var allPosts = [PostInfo]()
    
    // MARK: - Private Properties
    
    private var feedService: FeedServiceProtocol
    private var updateManager: UpdateManager
    
    // MARK: - Init
    
    init(
        feedService: FeedServiceProtocol = ServiceLayer.shared.feedService,
        updateManager: UpdateManager = ServiceLayer.shared.updateManager
    ) {
        self.feedService = feedService
        self.updateManager = updateManager
    }

    // MARK: - Public Properties
    
    func getFavouritePosts () {
        _ = feedService.getFavouritePosts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let posts):
                self.allPosts = posts
            case .failure(let error):
                print("Check Fail", error)
            }
        }
    }
    
    func removeLikeFromPost(id: String) {
        if let idIndex = allPosts.firstIndex(where: { $0.id == id }) {
            self.updateManager.isUpdateFavoritePostsNeeded = true
            allPosts.remove(at: idIndex)
            _ = feedService.removeLikeFromPost(postID: id) { _ in }
        }
    }
    
    func addLikedPost(post: PostInfo) {
        self.updateManager.isUpdateFavoritePostsNeeded = true
        allPosts.append(post)
        _ = feedService.addLikeToPost(postID: post.id) { _ in }
    }
    
}
