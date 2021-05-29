//
//  AdNewPostEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

import Alamofire

public struct AddNewPostEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = PostInfo
    
    // MARK: - Private Properties
    
    private let postInfo: PostInfo
    public let token: String?
    
    // MARK: - Init
    
    public init(postInfo: PostInfo, token: String?) {
        self.postInfo = postInfo
        self.token = token
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws -> PostInfo {
        return try JSONDecoder.default.decode(PostInfo.self, from: body)
    }
    
    public func makeRequest() throws -> URLRequest {
        
        guard let token = token else { throw DefaultServiceErrors.nilToken }
        
        let parameterS = createParameterDictionary(post: postInfo)!

        let headerS: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let requst = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameterS {
                    multipartFormData.append(value, withName: key)

                }
            },
            to: "https://interns2021.redmadrobot.com/me/posts", method: .post, headers: headerS)
            .validate(statusCode: 200...300)
            .response { _ in }
        
        return requst.convertible.urlRequest!
    }
    
    private func createParameterDictionary(post: PostInfo) -> [String: Data]? {
        var params: [String: Data] = [:]
        
        params["text"] = post.text?.data(using: .utf8)
        params["image_file"] = post.imageUrl?.dataRepresentation
        params["lat"] = withUnsafeBytes(of: post.lat) { Data($0) }
        params["lon"] = withUnsafeBytes(of: post.lon) { Data($0) }
        
        return params
    }
        
}
