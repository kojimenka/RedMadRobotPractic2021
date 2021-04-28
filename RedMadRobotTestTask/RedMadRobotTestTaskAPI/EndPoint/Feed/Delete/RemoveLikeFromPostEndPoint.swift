//
//  RemoveLikeFromPostEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct RemoveLikeFromPostEndPoint: EmptyEndpoint, URLRequestBuildable {
    
    // MARK: - Public Properties
    
    public typealias Content = Void
    
    // MARK: - Private Properties
    
    private let postID: String
    
    // MARK: - Init
    
    public init(postID: String) {
        self.postID = postID
    }
    
    // MARK: - Public Methods
    
    public func makeRequest() throws -> URLRequest {
        let url = URL(string: "feed")!.appendingPathComponent(postID).appendingPathComponent("like")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return request
    }
        
}
