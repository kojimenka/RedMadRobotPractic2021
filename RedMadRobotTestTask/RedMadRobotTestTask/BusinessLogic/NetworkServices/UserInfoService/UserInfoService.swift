//
//  UserInfoService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class UserInfoService: ApiService, UserInfoServiceProtocol {
        
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    public func getUserInfo(
        completion: @escaping (Result<UserInformation, Error>) -> Void)
    -> Progress {
        let endpoint = GetUserInfoEndpoint()
        return apiClient.request(endpoint) { result in
            switch result {
            case .success(let content):
                completion(.success(UserInformation(content)))
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
    
    public func getUserFriends(
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserFriendsEndpoint()
        return apiClient.request(endpoint) { result in
            switch result {
            case .success(let content):
                completion(.success(content.map { UserInformation($0) }))
            case .failure(let error):
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    // MARK: - Post request
    
    public func addFriend(
        friendID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = AddFriendEndpoint(friendID: friendID)
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
    
    // MARK: - Put request
    
    public func updateUserInfo(
        user: UserInformation,
        completion: @escaping (Result<Void, Error>) -> Void)
     -> Progress {
        let endpoint = UpdateUserInfoEndpoint(user: RedMadRobotTestTaskAPI.UserInformation(user),
                                              token: UserDefaultsUserStorage().accessToken)
        return apiClient.request(endpoint) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error.unwrapAFError()))
            }
        }
    }
    
    // MARK: - Delete request
    
    public func deleteFriend(
        friendID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = DeleteUserFriendEndpoint(userId: friendID)
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
