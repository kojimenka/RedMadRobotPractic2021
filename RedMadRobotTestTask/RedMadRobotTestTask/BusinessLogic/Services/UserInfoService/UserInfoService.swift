//
//  UserInfoService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class UserInfoService {
    
    // MARK: - Private Properties
    
    private let apiClient: Client
    
    // MARK: - Init
    
    public init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    public func getUserInfo(
        token: String,
        completion: @escaping (Result<UserInformation, Error>) -> Void)
    -> Progress {
        let endpoint = UserInfoEndPoint()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getUserPosts(
        token: String,
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetUserPosts()
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
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
        let endPoint = AdNewPostEndPoint(postInfo: postInfo)
        return apiClient.upload(endPoint, completionHandler: completion)
    }
    
}
