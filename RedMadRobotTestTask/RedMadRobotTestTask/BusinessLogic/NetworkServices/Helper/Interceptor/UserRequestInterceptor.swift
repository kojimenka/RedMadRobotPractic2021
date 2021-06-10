//
//  UserRequestInterceptor.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Alamofire

class UserRequestInterceptor: UserRequestRetrier, RequestInterceptor {
    
    // MARK: - Public Properties
    
    public var baseURL: URL
    
    // MARK: - Private Properties
    
    private let storage: DataInRamManager
    
    private var accessToken: String {
        return storage.accessToken ?? ""
    }
    
    // MARK: - Init
    
    public init(
        baseURL: URL,
        storage: DataInRamManager
    ) {
        self.baseURL = baseURL
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        
        guard let url = urlRequest.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = urlRequest
        request.url = appendingBaseURL(to: url)
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(request))
    }
    
    // MARK: - Private Methods
    
    private func appendingBaseURL(to url: URL) -> URL {
        URL(string: url.absoluteString, relativeTo: baseURL)!
    }
}
