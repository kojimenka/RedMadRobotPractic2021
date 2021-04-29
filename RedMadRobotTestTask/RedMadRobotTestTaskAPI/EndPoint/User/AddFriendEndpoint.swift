//
//  AddFriendEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

public struct AddFriendEndpoint: EmptyEndpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = Void
    
    // MARK: - Private Properties
    
    private let friendID: String
    
    // MARK: - Init
    
    public init(friendID: String) {
        self.friendID = friendID
    }
    
    // MARK: - Public Methods
        
    public func makeRequest() throws -> URLRequest {
        // prepare json data
        let json: [String: Any] = ["user_id": friendID]
        let jsonData = try JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "me/friends")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
        
}
