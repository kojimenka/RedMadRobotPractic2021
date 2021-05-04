//
//  DeleteUserPostEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct DeleteUserPostEndpoint: EmptyEndpoint, URLRequestBuildable {
    
    // MARK: - Public Properties
    
    public let idPostForDelete: String
    
    // MARK: - Init

    public init(idPostForDelete: String) {
        self.idPostForDelete = idPostForDelete
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "me/posts")!.appendingPathComponent(idPostForDelete)
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return request
    }
    
}
