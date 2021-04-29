//
//  LogoutEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

public struct LogoutEndpoint: EmptyEndpoint {
    
    // MARK: - Init
    
    public init() { }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
    
        // create post request
        let url = URL(string: "auth/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        return request
    }
        
}
