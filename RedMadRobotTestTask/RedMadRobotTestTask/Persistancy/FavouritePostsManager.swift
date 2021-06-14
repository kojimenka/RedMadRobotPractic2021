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
    func getFavouritePosts(completion: @escaping () -> Void )
}

/// Класс ответственный за хранение любимых пользователем постов. Он помогает не обновлять полностью ленту постов после изменения статуса поста
final class FavouritePostsManagerImpl: FavouritePostsManager {
    
    // MARK: - Public Properties
    
    /// Список со всем избранными постами
    public var allPosts = [PostInfo]()
    
    // MARK: - Private Properties
    
    private var feedService: FeedService
    private var updateManager: UpdateManager
    
    // MARK: - Init
    
    init(
        feedService: FeedService = ServiceLayer.shared.feedService,
        updateManager: UpdateManager = ServiceLayer.shared.updateManager
    ) {
        self.feedService = feedService
        self.updateManager = updateManager
    }

    // MARK: - Public Properties
    
    func getFavouritePosts(completion: @escaping () -> Void ) {
        _ = feedService.getFavouritePosts { [weak self] result in
            guard let self = self else { return }
            completion()
            switch result {
            case .success(let posts):
                self.allPosts = posts
            case .failure:
                break
            }
        }
    }
    
    /// Метод для удаления поста. Удаляем пост из локального списка избранных постов, затем делаем запрос на удаления на сервер
    /// - Parameter id: ID поста
    func removeLikeFromPost(id: String) {
        if let idIndex = allPosts.firstIndex(where: { $0.id == id }) {
            self.updateManager.isUpdateFavoritePostsNeeded = true
            allPosts.remove(at: idIndex)
            _ = feedService.removeLikeFromPost(postID: id) { _ in }
        }
    }
    
    /// Метод для добавления поста. Добавляем пост в локальный список избранных постов, затем делаем запрос на добавление на сервер
    /// - Parameter id: ID поста
    func addLikedPost(post: PostInfo) {
        self.updateManager.isUpdateFavoritePostsNeeded = true
        allPosts.append(post)
        _ = feedService.addLikeToPost(postID: post.id) { _ in }
    }
    
}
