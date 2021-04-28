//
//  UserInfoService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class UserInfoService: UserInfoServiceProtocol {
    
    // MARK: - Public Properties
    
    public let apiClient: Client
    
    // MARK: - Init
    
    public init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    public func getUserInfo(
        completion: @escaping (Result<UserInformation, Error>) -> Void)
    -> Progress {
        let endpoint = GetUserInfoEndPoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getUserPosts(
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserPostsEndPoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getUserFriends(
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserFriendsEndPoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    // MARK: - Post request
    
    public func addFriend(
        friendID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = AddFriendEndPoint(friendID: friendID)
        return apiClient.upload(endPoint, completionHandler: completion)
    }
    
    public func addPost(
        postInfo: UserPostInfo,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = AddNewPostEndPoint(postInfo: postInfo)
        return apiClient.upload(endPoint, completionHandler: completion)
    }
    
    // MARK: - Put request
    
    public func updateUserInfo(
        user: UserInformation,
        completion: @escaping (Result<Void, Error>) -> Void)
     -> Progress {
        let endPoint = UpdateUserInfoEndPoint(user: user,
                                              token: UserDefaultsUserStorage().accessToken!)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
    // MARK: - Delete request
    
    public func deleteFriend(
        friendID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = DeleteUserFriendEndPoint(idUserForDelete: friendID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
    public func deletePost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress {
        let endPoint = DeleteUserPostEndPoint(idPostForDelete: postID)
        return apiClient.request(endPoint, completionHandler: completion)
    }
    
}
