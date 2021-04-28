//
//  GetFavouritePostsEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct GetFavouritePostsEndPoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = [UserPostInfo]

    // MARK: - Init
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "feed/favorite")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> [UserPostInfo] {
        let content = try? JSONDecoder().decode([UserPostInfo].self, from: body)
        return content ?? []
    }

}
