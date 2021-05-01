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
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getUserPosts(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserPostsEndpoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getUserFriends(
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserFriendsEndpoint()
        return apiClient.request(endpoint, completionHandler: completion)
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
        let endPoint = AddNewPostEndpoint(postInfo: postInfo,
                                          token: UserDefaultsUserStorage().accessToken!)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
    // MARK: - Put request
    
    public func updateUserInfo(
        user: UserInformation,
        completion: @escaping (Result<Void, Error>) -> Void)
     -> Progress {
        let endPoint = UpdateUserInfoEndpoint(user: user,
                                              token: UserDefaultsUserStorage().accessToken!)
        return apiClient.request(endPoint, completionHandler: completion)
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
