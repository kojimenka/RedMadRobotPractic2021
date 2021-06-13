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
    
    // MARK: - Put request
    
    func updateUserInfo(
        user: AddUserInformationModel,
        completion: @escaping (Result<UserInformation, Error>) -> Void)
    -> Progress {
        let endpoint = UpdateUserInfoEndpoint(
            user: RedMadRobotTestTaskAPI.AddUserInformationModel(user)
        )
        
        return apiClient.request(endpoint) { result in
            switch result {
            case .success(let content):
                completion(.success(UserInformation(content)))
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
    
}
