//
//  GetUserPostsEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

public struct GetUserPostsEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = [PostInfo]

    // MARK: - Init
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "me/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> [PostInfo] {
        let content = try JSONDecoder.default.decode([PostInfo].self, from: body)
        return content
    }

}
