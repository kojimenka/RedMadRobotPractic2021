//
//  UpdateUserInfoEndPoint.swift
//  RedMadRobotTestTaskAPI
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Apexy

import Alamofire

public struct UpdateUserInfoEndpoint: Endpoint {
    
    // MARK: - Public Properties
    
    public typealias Content = Void
    
    // MARK: - Private Properties

    public let user: UserInformation
    public let token: String?
    
    // MARK: - Init
    
    public init(user: UserInformation, token: String?) {
        self.user = user
        self.token = token
    }
    
    // MARK: - Public Methods
    
    public func content(from response: URLResponse?, with body: Data) throws {
        try ResponseValidator.validate(response, with: body)
    }
    
    public func makeRequest() throws -> URLRequest {
    
        guard let token = token else { throw DefaultServiceErrors.nilToken }
        
        let parameterS = createParameterDictionary(user: user)!
        
        let headerS: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let requst = AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in parameterS {
                    multipartFormData.append(value, withName: key)

                }
            },
            to: "https://interns2021.redmadrobot.com/me", method: .patch, headers: headerS)
            .validate(statusCode: 200...300)
            .response { _ in }
        
        return requst.convertible.urlRequest!
    }
    
    // MARK: - Private Methods
    
    private func createParameterDictionary(user: UserInformation) -> [String: Data]? {
        var params: [String: Data] = [:]
        
        params["first_name"] = user.firstName.data(using: .utf8)
        params["last_name"] = user.lastName.data(using: .utf8)
        params["nickname"] = user.nickname?.data(using: .utf8)
        params["avatar_url"] = user.avatarUrl?.dataRepresentation
        params["birth_day"] = user.birthDay.data(using: .utf8)
        
        return params
    }
}
