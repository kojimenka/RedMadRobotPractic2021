//
//  AdNewPostEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct AddNewPostEndPoint: UploadEndpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = Void
    
    // MARK: - Private Properties
    
    private let postInfo: UserPostInfo
    
    // MARK: - Init
    
    public init(postInfo: UserPostInfo) {
        self.postInfo = postInfo
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws {
        try ResponseValidator.validate(response, with: body)
    }
    
    public func makeRequest() throws -> (URLRequest, UploadEndpointBody) {
        
        // prepare json data
        let jsonData = try? JSONEncoder().encode(postInfo)

        // create post request
        let url = URL(string: "me/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        // insert json data to the request
        request.httpBody = jsonData
        
        return (request, .data(jsonData ?? Data()))
    }
        
}
