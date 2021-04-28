//
//  GetSortedPostsEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

public struct GetSortedPostsEndPoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = [UserPostInfo]
    
    public let predicate: String
    
    // MARK: - Init
    
    public init(predicate: String) {
        self.predicate = predicate
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "search?post=\(predicate)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> [UserPostInfo] {
        let content = try? JSONDecoder().decode([UserPostInfo].self, from: body)
        return content ?? []
    }

}
