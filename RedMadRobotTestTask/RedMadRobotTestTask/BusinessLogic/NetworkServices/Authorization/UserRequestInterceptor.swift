//
//  UserRequestInterceptor.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 27.04.2021.
//

import Alamofire

struct UserRequestInterceptor: RequestInterceptor {
    
    // MARK: - Public Properties
    
    public var baseURL: URL
    
    // MARK: - Private Properties
    
    private let storage: UserStorage
    
    private var accessToken: String {
        return storage.accessToken ?? ""
    }
    
    // MARK: - Init
    
    public init(
        baseURL: URL,
        storage: UserStorage
    ) {
        self.baseURL = baseURL
        self.storage = storage
    }
    
    // MARK: - Public Methods
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        // Временный вариант
        
        if request.response?.statusCode == 401 {
            _ = ServiceLayer.shared.authorizationServices.refreshToken { result in
                switch result {
                case .success:
                    completion(.retry)
                case .failure:
                    completion(.doNotRetry)
                }
            }
            return
        }

        completion(.doNotRetry)
    }
    
    public func adapt(
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
        
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(request))
    }
    
    // MARK: - Private Methods
    
    private func appendingBaseURL(to url: URL) -> URL {
        URL(string: url.absoluteString, relativeTo: baseURL)!
    }
}
