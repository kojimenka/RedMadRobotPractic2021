//
//  RequestInterceptor.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Alamofire

class UserRequestInterceptor: RequestInterceptor {
    
    open var baseURL: URL
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>)
            -> Void
    ) {
        
        guard let url = urlRequest.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = urlRequest
        request.url = appendingBaseURL(to: url)
        
        if let token = UserDefaultsUserStorage().accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        completion(.success(request))
    }
    
    private func appendingBaseURL(to url: URL) -> URL {
        URL(string: url.absoluteString, relativeTo: baseURL)!
    }
}
