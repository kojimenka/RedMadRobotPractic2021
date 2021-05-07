//
//  RefreshUserTokenEndpoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 28.04.2021.
//

import Apexy

public struct RefreshUserTokenEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = AuthTokens
    
    // MARK: - Private Properties
    
    private let token: String
    
    // MARK: - Init
    
    public init(token: String) {
        self.token = token
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws -> AuthTokens {
        try ResponseValidator.validate(response, with: body)
        return try JSONDecoder.default.decode(AuthTokens.self, from: body)
    }
    
    public func makeRequest() throws -> URLRequest {
        // prepare json data
        let json: [String: Any] = ["token": token]

        let jsonData = try JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "auth/refresh")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    
        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
}
