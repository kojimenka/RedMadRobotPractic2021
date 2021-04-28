//
//  SearchService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class SearchService: SearchServiceProtocol {
    
    // MARK: - Public Properties
    
    public let apiClient: Client
    
    // MARK: - Init
    
    public init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    public func getSortedUsers(
        predicate: String,
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress {
        let endpoint = GetSearchedUserEndPoint(predicate: predicate)
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getSortedPosts(
        predicate: String,
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetSortedPostsEndPoint(predicate: predicate)
        return apiClient.request(endpoint, completionHandler: completion)
    }
}
