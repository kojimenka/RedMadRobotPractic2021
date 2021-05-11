//
//  PostsFeedRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 08.05.2021.
//

import UIKit

protocol PostsFeedRequestViewModelProtocol: AnyObject {
    init(feedService: FeedServiceProtocol)
    func getPosts(
        screenState: PostsScreenState,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class PostsFeedRequestViewModel: NSObject, PostsFeedRequestViewModelProtocol {
    
    // MARK: - Public properties
    
    // Я еще не реализовал маппер который бы переделывал структуры с API таргета на основной тагрет, в будущем эти данные и будут показываться в коллекции
    
//    public var allPosts: [PostInfo] = []
    
    // MARK: - Private properties
    
    private let feedService: FeedServiceProtocol
    
    // MARK: - Init
    
    init(feedService: FeedServiceProtocol = ServiceLayer.shared.feedService) {
        self.feedService = feedService
    }
    
    // MARK: - Methods
    
    //Для тестов всегда возвращает failure, поэтому если вызвать этот запрос в контоллере, то контоллера покажет Zero Screen
    
    public func getPosts(
        screenState: PostsScreenState,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        completion(.failure(LoginValidatorError.emptyLogin))
        switch screenState {
        case .feedScreen:
            break
//            feedService.getFeed { [weak self] result in
//                guard let self = self else { return }
//                switch result {
//                case .success(let data):
//                    break
//                    completion(.success(()))
//                case .failure(let error):
//                    completion(.failure(error))
//                }
//            }
        case .userPosts:
            break
        case .userFavoritePosts:
            break
        }
    }
    
}
