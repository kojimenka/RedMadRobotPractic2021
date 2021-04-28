//
//  LogoutEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

public struct LogoutEndPoint: UploadEndpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = Void?
    
    // MARK: - Private Properties
    
    private let refreshToken: String
    
    // MARK: - Init
    
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws -> Void? {
        try ResponseValidator.validate(response, with: body)
    }
    
    public func makeRequest() throws -> (URLRequest, UploadEndpointBody) {
        // prepare json data
        let json: [String: Any] = ["token": refreshToken]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "auth/logout")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        
        return (request, .data(jsonData ?? Data()))
    }
        
}
