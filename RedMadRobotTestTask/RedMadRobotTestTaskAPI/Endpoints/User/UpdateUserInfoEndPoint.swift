//
//  UpdateUserInfoEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

// swiftlint:disable line_length
public struct UpdateUserInfoEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = UserInformation
    
    // MARK: - Private Properties

    public let user: AddUserInformationModel
    
    // MARK: - Init
    
    public init(user: AddUserInformationModel) {
        self.user = user
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws -> UserInformation {
        return try JSONDecoder.default.decode(UserInformation.self, from: body)
    }
    
    public func makeRequest() throws -> URLRequest {
        
        let url = URL(string: "me")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        var parameters: [String: String] = [:]
        
        parameters["first_name"] = user.firstName
        parameters["last_name"] = user.lastName
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: user.birthDay)
        parameters["birth_day"] = stringDate
        
        if let nickname = user.nickname {
            parameters["nickname"] = nickname
        }
        
        let boundary = UUID().uuidString
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBody(
            boundary: boundary,
            with: parameters,
            imageData: user.imageData
        )
        
        return request
    }

    // MARK: - Private Methods
    
    private func createBody(boundary: String, with parameters: [String: String], imageData: Data?) -> Data {
        var body = Data()
        let imageName = "\(UUID().uuidString).jpeg"
        let paramName = "avatar_file"
        
        for (key, value) in parameters {
            body.append(string: "--\(boundary)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append(string: "\(value)\r\n")
        }
        
        if let imageData = imageData {
            body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(imageName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        }
        
        body.append(string: "--\(boundary)--\r\n")
        return body
    }
}
