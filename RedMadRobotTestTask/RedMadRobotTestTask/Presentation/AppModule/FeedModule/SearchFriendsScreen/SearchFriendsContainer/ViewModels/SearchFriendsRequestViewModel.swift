//
//  SearchFriendsRequestViewModel.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 16.05.2021.
//

import Foundation

protocol SearchFriendsRequestViewModel {
    func searchFriends(name: String, completion: @escaping (Result<[UserInformation], Error>) -> Void)
    func getUserFriends(completion: @escaping (Result<[UserInformation], Error>) -> Void)
    func addNewFriend(id: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class SearchFriendsRequestViewModelImpl: SearchFriendsRequestViewModel {
    
    // MARK: - Properties
    
    private let searchService: SearchService
    private let userService: UserInfoService
    
    private var userFriendsCompletion: (((Result<[UserInformation], Error>) -> Void)?)
    private var userFriends = [UserInformation]()
    
    // MARK: - Init
    
    init(
        searchService: SearchService = ServiceLayer.shared.searchService,
        userService: UserInfoService = ServiceLayer.shared.userInfoService
    ) {
        self.userService = userService
        self.searchService = searchService
    }
    
    // MARK: - Public Methods
    
    public func searchFriends(
        name: String,
        completion: @escaping (Result<[UserInformation], Error>) -> Void
    ) {
        _ = searchService.getSortedUsers(predicate: name) { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addNewFriend(
        id: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        _ = userService.addFriend(friendID: id) { result in
            switch result {
            case .success:
                completion(.success(id))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getUserFriends(
        completion: @escaping (Result<[UserInformation], Error>) -> Void
    ) {
        userFriendsCompletion = completion
        _ = userService.getUserFriends { result in
            switch result {
            case .success(let users):
                self.userFriends = users
                self.getUserInfo()
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func getUserInfo() {
        _ = userService.getUserInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.userFriends.append(user)
                self.userFriendsCompletion?(.success(self.userFriends))
            case .failure(let error):
                self.userFriendsCompletion?(.failure(error))
            }
        }
    }
    
}
