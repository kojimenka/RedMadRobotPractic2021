//
//  ServiceLayer.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import Apexy

import Alamofire

import RedMadRobotTestTaskAPI

final class ServiceLayer {
    
    // MARK: - Public Properties
    
    public static var shared = ServiceLayer()
    
    // Networks
    
    lazy public var authorizationServices: AuthorizationServiceProtocol = AuthorizationServices(
        apiClient: apiClient,
        storage: userStorage
    )
    
    lazy public var userInfoService: UserInfoServiceProtocol = UserInfoService(apiClient: apiClient)
    
    lazy public var feedService: FeedServiceProtocol = FeedService(apiClient: apiClient)
    
    lazy public var searchService: SearchServiceProtocol = SearchService(apiClient: apiClient)
    
    // DataBase
    
    lazy public var userStorage: UserStorage = UserDefaultsUserStorage()
    
    // MARK: - Private Properties
    
    private(set) lazy var apiClient: Client = {
        return AlamofireClient(
            requestInterceptor: UserRequestInterceptor(
                baseURL: URL(string: "https://interns2021.redmadrobot.com")!,
                storage: userStorage),
            configuration: .ephemeral)
    }()
    
    // MARK: - Init
    
    private init() {}
    
}