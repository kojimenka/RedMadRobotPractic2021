//
//  AdNewPostEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

// swiftlint:disable line_length
public struct AddNewPostEndpoint: Endpoint {

    // MARK: - Public Properties
    
    public typealias Content = PostInfo
    
    // MARK: - Private Properties
    
    private let postInfo: AddPostModel
    
    // MARK: - Init
    
    public init(postInfo: AddPostModel) {
        self.postInfo = postInfo
    }
    
    // MARK: - Public Methods
    public func content(from response: URLResponse?, with body: Data) throws -> PostInfo {
        return try JSONDecoder.default.decode(PostInfo.self, from: body)
    }
    
    public func makeRequest() throws -> URLRequest {

        let url = URL(string: "me/posts")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        var parameters: [String: String] = [:]
        
        if let text = postInfo.text {
            parameters["text"] = text
        }
        
        if let lon = postInfo.lon {
            parameters["lon"] = String(lon)
        }
        
        if let lat = postInfo.lat {
            parameters["lat"] = String(lat)
        }
        
        let boundary = UUID().uuidString
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBody(
            boundary: boundary,
            with: parameters,
            imageData: postInfo.imageData
        )

        return request
    }
    
    private func createBody(boundary: String, with parameters: [String: String], imageData: Data?) -> Data {
        var body = Data()
        let imageName = "\(UUID().uuidString).jpeg"
        let paramName = "image_file"
        
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

extension Data {
    mutating func append(string: String) {
        guard let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true) else { return }
        append(data)
    }
}
