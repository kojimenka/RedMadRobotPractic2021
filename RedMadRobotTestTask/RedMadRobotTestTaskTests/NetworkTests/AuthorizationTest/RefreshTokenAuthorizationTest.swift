//
//  RefreshTokenAuthorizationTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class RefreshTokenAuthorizationTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<RefreshUserTokenEndpoint>!
    private var authorizationService: AuthorizationService!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<RefreshUserTokenEndpoint>()
        authorizationService = AuthorizationServiceImpl(
            apiClient: client,
            tokenManager: MockTokenManager(),
            keychainManager: MockKeychainManager()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        authorizationService = nil
    }
    
    // MARK: - Methods
    
    func testSuccessRefreshToken() {
        
        let requestExpectation = expectation(description: #function)
        var requestResult: Bool?
        
        client.result = .success(mockModels.differentTokenData)
        
        _ = authorizationService.refreshToken { result in
            if case .success = result {
                requestResult = true
            }
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertEqual(requestResult, true)
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureRefreshToken() {
        
        let requestExpectation = expectation(description: #function)
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = authorizationService.refreshToken { result in
            if case .failure(let error) = result {
                requestResult = false
                requestError = error
            }
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertEqual(requestResult, false)
            XCTAssertEqual(requestError?.localizedDescription, MockWarnings.mockError.localizedDescription)
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
}
