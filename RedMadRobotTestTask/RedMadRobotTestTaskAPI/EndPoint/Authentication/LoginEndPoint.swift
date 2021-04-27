//
//  LoginEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 26.04.2021.
//

import Apexy

public struct UserLoginEndPoint: UploadEndpoint {
    
    public typealias Content = AuthTokens?
    
    private let email: String
    private let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    public func content(from response: URLResponse?, with body: Data) throws -> AuthTokens? {
        try ResponseValidator.validate(response, with: body)
        return try? JSONDecoder().decode(AuthTokens.self, from: body)
    }
    
    public func makeRequest() throws -> (URLRequest, UploadEndpointBody) {
        // prepare json data
        let json: [String: Any] = ["email": email,
                                   "password": password]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // insert json data to the request
        request.httpBody = jsonData
        
        return (request, .data(jsonData ?? Data()))
    }
        
}
