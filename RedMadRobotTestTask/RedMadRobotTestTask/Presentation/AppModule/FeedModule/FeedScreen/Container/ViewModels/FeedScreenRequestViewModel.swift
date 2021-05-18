//
//  FeedScreenRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.05.2021.
//

import Foundation

protocol FeedScreenRequestViewModel {
    func addLike(postID: String)
}

final class FeedScreenRequestViewModelImpl: FeedScreenRequestViewModel {
    
    // MARK: - Properties
    
    private let feedService: FeedServiceProtocol
    
    // MARK: - Init
    
    init(feedService: FeedServiceProtocol = ServiceLayer.shared.feedService) {
        self.feedService = feedService
    }
    
    // MARK: - Public Methods
    
    public func addLike(postID: String) {
        _ = feedService.addLikeToPost(postID: postID) { result in
            switch result {
            case .success:
                print("DEBUG: Success add like")
            case .failure(let error):
                print("DEBUG: Failure add like with error  \(error.localizedDescription)")
            }
        }
    }
}
