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
    
    public func getUserPosts(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserPostsEndpoint()
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
    
    public func addPost(
        postInfo: PostInfo,
        completion: @escaping (Result<PostInfo, Error>) -> Void)
    -> Progress {
        let endPoint = AddNewPostEndpoint(postInfo: RedMadRobotTestTaskAPI.PostInfo(postInfo),
                                          token: ServiceLayer.shared.dataInRamManager.accessToken)
        return apiClient.request(endPoint) { result in
            switch result {
            case .success(let content):
                completion(.success(PostInfo(content)))
            case .failure(let error):
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    // MARK: - Delete request
    
    public func removeLikeFromPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = RemoveLikeFromPostEndpoint(postID: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
    public func deletePost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = DeleteUserPostEndpoint(idPostForDelete: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
}
