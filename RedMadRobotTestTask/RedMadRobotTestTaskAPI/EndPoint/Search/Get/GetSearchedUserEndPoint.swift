//
//  GetSearchedUserEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

public struct GetSearchedUserEndPoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = [UserInformation]
    
    public let predicate: String
    
    // MARK: - Init
    
    public init(predicate: String) {
        self.predicate = predicate
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "search?user=\(predicate)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> [UserInformation] {
        let content = try? JSONDecoder().decode([UserInformation].self, from: body)
        return content ?? []
    }

}
