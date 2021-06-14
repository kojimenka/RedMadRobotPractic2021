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
    
    lazy public var authorizationServices: AuthorizationService = AuthorizationServiceImpl(
        apiClient: apiClient,
        dataInRamManager: dataInRamManager,
        keychainManager: keychainManager
    )
    
    lazy public private(set) var userInfoService: UserInfoService = UserInfoServiceImpl(apiClient: apiClient)
    
    lazy public private(set) var feedService: FeedService = FeedServiceImpl(apiClient: apiClient)
    
    lazy public private(set) var searchService: SearchService = SearchServiceImpl(apiClient: apiClient)
    
    // Persistancy
    
    public private(set) var dataInRamManager: DataInRamManager = DataInRamManagerImpl()
    public private(set) var updateManager: UpdateManager = UpdateManagerImpl()
    public private(set) var keychainManager: KeychainManager = KeychainManagerImpl()
    
    lazy public private(set) var favouritePostsManager: FavouritePostsManager = FavouritePostsManagerImpl(
        feedService: feedService
    )
    
    // MARK: - Private Properties
    
    private(set) lazy var apiClient: Client = {
        return AlamofireClient(
            requestInterceptor: UserRequestInterceptor(
                baseURL: URL(string: "https://interns2021.redmadrobot.com")!,
                storage: dataInRamManager
            ),
            configuration: .ephemeral
        )
    }()

    // MARK: - Init
    
    private init() {}
    
}
