//
//  GetSortedPostsEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

public struct GetSortedPostsEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = [PostInfo]
    
    // MARK: - Private Properties
    
    private let predicate: String
    
    // MARK: - Init
    
    public init(predicate: String) {
        self.predicate = predicate
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let escapedPredicate = predicate.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let url = URL(string: "search?post=\(escapedPredicate)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> [PostInfo] {
        let content = try JSONDecoder.default.decode([PostInfo].self, from: body)
        return content
    }

}
