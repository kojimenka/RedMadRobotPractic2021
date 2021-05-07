//
//  DeleteUserFriend.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct DeleteUserFriendEndpoint: EmptyEndpoint, URLRequestBuildable {
    
    // MARK: - Public Properties
    
    public let userId: String

    // MARK: - Init
    
    public init(userId: String) {
        self.userId = userId
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "me/friends")!.appendingPathComponent(userId)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return request
    }
    
}
