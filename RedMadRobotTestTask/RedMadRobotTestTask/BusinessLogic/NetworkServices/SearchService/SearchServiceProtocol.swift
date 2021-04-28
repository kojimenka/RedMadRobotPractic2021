//
//  SearchServiceProtocol.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

protocol SearchServiceProtocol {
    
    var apiClient: Client { get }
    init(apiClient: Client)
    
    // MARK: - Public Methods
    
    // MARK: - Get request
    
    func getSortedUsers(
        predicate: String,
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress
    
    func getSortedPosts(
        predicate: String,
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress
}
