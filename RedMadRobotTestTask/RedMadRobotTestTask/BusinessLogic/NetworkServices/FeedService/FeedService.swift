//
//  FeedService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class FeedService: FeedServiceProtocol {
    
    // MARK: - Public Properties
    
    public let apiClient: Client
    
    // MARK: - Init
    
    public init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    public func getFeed(
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetFeedEndPoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getFavouritePosts(
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetFavouritePostsEndPoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    // MARK: - Post request
    
    public func addLikeToPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = AddLikeToPostEndPoint(postID: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
    // MARK: - Delete request
    
    public func removeLikeFromPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = RemoveLikeFromPostEndPoint(postID: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
}
