//
//  UserLoginEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

public struct UserLoginEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = AuthTokens?
    
    // MARK: - Private Properties
    
    private let email: String
    private let password: String
    
    // MARK: - Init
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws -> AuthTokens? {
        return try JSONDecoder.default.decode(AuthTokens.self, from: body)
    }
    
    public func validate(_ request: URLRequest?, response: HTTPURLResponse, data: Data?) throws {
        try ResponseValidator.validate(response, with: data ?? Data())
    }
    
    public func makeRequest() throws -> URLRequest {
        // prepare json data
        let json: [String: Any] = ["email": email,
                                   "password": password]

        let jsonData = try JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }

}
