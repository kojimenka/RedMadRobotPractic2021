//
//  AddFriendEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct AddFriendEndPoint: UploadEndpoint {
    
    public typealias Content = Void
    
    private let friendID: String
    
    public init(friendID: String) {
        self.friendID = friendID
    }
    
    public func content(from response: URLResponse?, with body: Data) throws {
        try ResponseValidator.validate(response, with: body)
    }
    
    public func makeRequest() throws -> (URLRequest, UploadEndpointBody) {
        
        // prepare json data
        let json: [String: Any] = ["user_id": friendID]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "me/friends")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // insert json data to the request
        request.httpBody = jsonData
        
        return (request, .data(jsonData ?? Data()))
    }
        
}
