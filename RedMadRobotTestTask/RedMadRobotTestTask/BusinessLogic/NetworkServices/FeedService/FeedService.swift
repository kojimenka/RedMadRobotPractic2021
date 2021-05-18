//
//  FeedService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class FeedService: ApiService, FeedServiceProtocol {
        
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    public func getFeed(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetFeedEndpoint()
        return apiClient.request(endpoint) { result in
            switch result {
            case .success(let content):
                completion(.success(content.map { PostInfo($0) }))
            case .failure(let error):
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    public func getFavouritePosts(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetFavouritePostsEndpoint()
        return apiClient.request(endpoint) { result in
            switch result {
            case .success(let content):
                completion(.success(content.map { PostInfo($0) }))
            case .failure(let error):
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    // MARK: - Post request
    
    public func addLikeToPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = AddLikeToPostEndpoint(postID: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
    // MARK: - Delete request
    
    public func removeLikeFromPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = RemoveLikeFromPostEndpoint(postID: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
}
