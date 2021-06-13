//
//  UserInfoServiceProtocol.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

import RedMadRobotTestTaskAPI

protocol UserInfoServiceProtocol {
    
    // MARK: - Get request
    
    func getUserInfo(
        completion: @escaping (Result<UserInformation, Error>) -> Void)
    -> Progress
    func getUserFriends(
        completion: @escaping (Result<[UserInformation], Error>) -> Void)
    -> Progress
    
    // MARK: - Post request
    
    func addFriend(
        friendID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
    
    // MARK: - Put request
    
    func updateUserInfo(
        user: AddUserInformationModel,
        completion: @escaping (Result<UserInformation, Error>) -> Void)
    -> Progress
    
    // MARK: - Delete request
    
    func deleteFriend(
        friendID: String,
        completion: @escaping (Result<Void, Error>) -> Void)
    -> Progress
}
