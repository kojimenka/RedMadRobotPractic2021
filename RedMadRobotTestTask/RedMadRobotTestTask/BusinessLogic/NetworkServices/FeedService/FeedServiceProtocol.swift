//
//  FeedServiceProtocol.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

protocol FeedServiceProtocol {

    // MARK: - Get request
    
    func getFeed(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress
    func getUserPosts(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress
    func getFavouritePosts(
        completion: @escaping (Result<[PostInfo], Error>) -> Void)
    -> Progress
    
    // MARK: - Post request
    
    func addLikeToPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    func addPost(
        postInfo: PostInfo,
        completion: @escaping (Result<PostInfo, Error>) -> Void)
    -> Progress
    
    // MARK: - Delete request

    func removeLikeFromPost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    func deletePost(
        postID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress 
}
