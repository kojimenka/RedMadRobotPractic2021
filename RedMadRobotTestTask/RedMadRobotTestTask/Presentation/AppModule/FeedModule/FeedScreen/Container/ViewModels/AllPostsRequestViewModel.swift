//
//  AllPostsRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 12.05.2021.
//

import Foundation

final class AllPostsRequestViewModel: PostsFeedRequestViewModelProtocol {
    
    // MARK: - Private Properties
    
    private let feedService: FeedServiceProtocol
    
    // MARK: - Init
    
    init(feedService: FeedServiceProtocol) {
        self.feedService = feedService
    }
    
    // MARK: - Public methods
    
    func getPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) {
        _ = feedService.getFeed { result in
            switch result {
            case .success(let content):
                print(content)
                completion(.success(content))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
