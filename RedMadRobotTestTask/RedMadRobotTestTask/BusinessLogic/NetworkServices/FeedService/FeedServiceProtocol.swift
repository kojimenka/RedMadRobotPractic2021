//
//  FeedServiceProtocol.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

protocol FeedServiceProtocol {
    
    var apiClient: Client { get }
    init(apiClient: Client)
    
    // MARK: - Get request
    
    func getFeed(
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress
    func getFavouritePosts(
        completion: @escaping (Result<[UserPostInfo], Error>) -> Void)
    -> Progress
    
    // MARK: - Post request
    
    func addLikeToPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    // MARK: - Delete request

    func removeLikeFromPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
}
