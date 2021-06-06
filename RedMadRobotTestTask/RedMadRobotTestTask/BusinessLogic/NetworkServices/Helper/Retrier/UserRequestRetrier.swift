//
//  UserRequestRetrier.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 30.05.2021.
//

import Alamofire

class UserRequestRetrier: RequestRetrier {
    
    // MARK: - Private Properties
    
    private let retryLimit = 5
    private var lastProceededResponse: HTTPURLResponse?
    
    // MARK: - Public Methods
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
            
        guard let statusCode = request.response?.statusCode,
              300..<600 ~= statusCode
        else { return completion(.doNotRetry) }
        
        // Предотвращает многократное выполнение body для одного и того же ответа
        guard lastProceededResponse != request.response,
              request.retryCount + 1 < retryLimit
        else {
            return completion(.doNotRetry)
        }

        lastProceededResponse = request.response
        
        if statusCode == 401 {
            refreshToken(completion: completion)
            return
        }
        
        let delay = TimeInterval(request.retryCount) // Задержка следующего запроса равна номеру его попытки в секундах
        
        completion(.retryWithDelay(delay))
    }
    
    private func refreshToken(completion: @escaping (RetryResult) -> Void) {
        _ = ServiceLayer.shared.authorizationServices.refreshToken { result in
            switch result {
            case .success:
                completion(.retry)
            case .failure:
                completion(.doNotRetry)
            }
        }
    }
    
}
