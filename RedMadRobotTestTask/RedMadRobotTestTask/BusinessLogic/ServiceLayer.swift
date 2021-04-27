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
    
    lazy public var authorizationServices: AuthorizationServiceProtocol = AuthorizationServices(apiClient: apiClient)
    
    lazy public var userInfoService = UserInfoService(apiClient: apiClient)
    
    // MARK: - Private Properties
    
    private(set) lazy var apiClient: Client = {
        return AlamofireClient(
            baseURL: URL(string: "https://interns2021.redmadrobot.com")!,
            configuration: .ephemeral,
            responseObserver: { [weak self] _, _, _, error in
//
//                let test = try? JSONDecoder().decode([UserPostInfo].self, from: data!)
//
//                print("Check", test?.first, request, response, data, error?.localizedDescription)
                self?.validateSession(responseError: error)
            })
    }()
    
//    private(set) lazy var apiClien2: Client = {
//        return AlamofireClient(requestInterceptor: UserRequestInterceptor(baseURL: URL(string: "https://interns2021.redmadrobot.com")!),
//                               configuration: .ephemeral)
//    }()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Private Methods
    
    private func validateSession(responseError: Error?) {
        if let error = responseError as? APIError, error.code == .tokenInvalid {
            print(error.localizedDescription)
        }
    }
    
}
