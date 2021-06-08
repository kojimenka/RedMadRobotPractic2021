//
//  MockClient.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import Apexy

import Foundation

import RedMadRobotTestTask

final class MockClient<E: Endpoint>: Client {
    
    // MARK: - Public Properties
    
    public var requestCalled = false
    public var uploadCalled = false
    public var result: Result<E.Content, Error>?
    
    public var requestCallCount = 0
    public var uploadCallCount = 0
    
    // MARK: - Methods
    
    public func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void)
    -> Progress where T: Endpoint {
        
        requestCalled = true
        requestCallCount += 1
        
        switch result {
        case .success(let content):
            if let content = content as? T.Content {
                completionHandler(.success(content))
            }
        case .failure(let error):
            completionHandler(.failure(error))
        default:
            break
        }
        
        return Progress()
    }
    
    public func upload<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void)
    -> Progress where T: UploadEndpoint {
        
        requestCalled = true
        requestCallCount += 1
        
        switch result {
        case .success(let content):
            if let content = content as? T.Content {
                completionHandler(.success(content))
            }
        case .failure(let error):
            completionHandler(.failure(error))
        default:
            break
        }
        
        return Progress()
    }
    
}
