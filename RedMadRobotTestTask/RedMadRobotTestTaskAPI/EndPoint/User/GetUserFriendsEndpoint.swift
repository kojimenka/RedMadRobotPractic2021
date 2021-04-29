//
//  GetUserFriends.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct GetUserFriendsEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = [UserInformation]

    // MARK: - Init
    
    public init() {}
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "me/friends")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return request
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> [UserInformation] {
        let content = try JSONDecoder.default.decode([UserInformation].self, from: body)
        return content
    }

}
