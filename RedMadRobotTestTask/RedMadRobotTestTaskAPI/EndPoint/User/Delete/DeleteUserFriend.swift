//
//  DeleteUserFriend.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct DeleteUserFriendEndPoint: EmptyEndpoint, URLRequestBuildable {
    
    // MARK: - Public Properties
    
    public let idUserForDelete: String

    // MARK: - Init
    
    public init(idUserForDelete: String) {
        self.idUserForDelete = idUserForDelete
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "me/friends")!.appendingPathComponent(idUserForDelete)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return request
    }
    
}
