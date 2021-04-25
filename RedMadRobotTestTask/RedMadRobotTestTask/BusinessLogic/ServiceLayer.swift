//
//  ServiceLayer.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 25.04.2021.
//

import Foundation

final class ServiceLayer {
    
    // MARK: - Public Properties
    
    public static var shared = ServiceLayer()
    
    public var authorizationServices: AuthorizationServiceProtocol = AuthorizationServices()
    
    // MARK: - Init
    
    private init() {}
    
}
