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
                                          token: UserDefaultsUserStorage().accessToken)
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

final class MockFeedService: FeedServiceProtocol {
    func getUserPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func addPost(postInfo: PostInfo, completion: @escaping (Result<PostInfo, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func deletePost(postID: String, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    var countOfRequest = 0
    
    func getFeed(completion: @escaping (Result<[PostInfo], Error>) -> Void) -> Progress {
        if countOfRequest == 0 {
            completion(.failure(LoginValidatorError.emptyLogin))
        } else if countOfRequest == 2 {
            completion(.success([PostInfo(
                                    id: "",
                                    text: "Test123456",
                                    imageUrl: nil,
                                    lon: nil,
                                    lat: nil,
                                    likes: 0,
                                    author: UserInformation())
            ]))
        } else if countOfRequest == 1 {
            completion(.success([]))
        }
        
        countOfRequest += 1
        
        return Progress()
    }
    
    func getFavouritePosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func addLikeToPost(postID: String, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func removeLikeFromPost(postID: String, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
}

final class MockUserService: UserInfoServiceProtocol {
    
    var countOfRequest = 0
    
    func getUserInfo(completion: @escaping (Result<UserInformation, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func getUserPosts(completion: @escaping (Result<[PostInfo], Error>) -> Void) -> Progress {
        
        if countOfRequest == 0 {
            completion(.failure(LoginValidatorError.emptyLogin))
        } else {
            completion(.success([PostInfo(
                                    id: "",
                                    text: nil,
                                    imageUrl: nil,
                                    lon: nil,
                                    lat: nil,
                                    likes: 0,
                                    isLikedPost: true,
                                    author: UserInformation())]
            )
            )
        }
        
        countOfRequest += 1
        
        return Progress()
    }
    
    func getUserFriends(completion: @escaping (Result<[UserInformation], Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func addFriend(friendID: String, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func addPost(postInfo: PostInfo, completion: @escaping (Result<PostInfo, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func updateUserInfo(user: UserInformation, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func deleteFriend(friendID: String, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
    
    func deletePost(postID: String, completion: @escaping (Result<Void, Error>) -> Void) -> Progress {
        return Progress()
    }
}
