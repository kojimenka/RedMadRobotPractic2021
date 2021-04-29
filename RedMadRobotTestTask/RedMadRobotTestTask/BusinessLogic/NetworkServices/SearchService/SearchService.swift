//
//  SearchService.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

public final class SearchService: ApiService, SearchServiceProtocol {
        
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    public func getSortedUsers(
        predicate: String,
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress {
        let endpoint = GetSearchedUserEndpoint(predicate: predicate)
        return apiClient.request(endpoint, completionHandler: completion)
    }
    
    public func getSortedPosts(
        predicate: String,
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress {
        let endpoint = GetSortedPostsEndpoint(predicate: predicate)
        return apiClient.request(endpoint, completionHandler: completion)
    }
}
