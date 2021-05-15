//
//  UserPostsRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.05.2021.
//

import Foundation

final class UserPostsRequestViewModel: PostsFeedRequestViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let feedService: FeedServiceProtocol
    
    // MARK: - Init
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    // MARK: - Public methods
    
    func getPosts(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.failure(LoginValidatorError.emptyLogin))
        
//        feedService.getFeed { result in
//
//        }
    }
}
