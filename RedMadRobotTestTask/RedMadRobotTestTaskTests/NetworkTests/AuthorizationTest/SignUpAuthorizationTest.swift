//
//  SignUpAuthorizationTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class SignUpAuthorizationTest: XCTestCase {
    
    // MARK: - Properties
    
    private var client: MockClient<UserRegistrationEndpoint>!
    private var authorizationService: AuthorizationService!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<UserRegistrationEndpoint>()
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
    
    func testSuccessSignUp() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        
        client.result = .success(mockModels.tokenData)
        
        _ = authorizationService.signUp(
            credentials: Credentials(
                email: mockModels.email,
                password: mockModels.password)
            ) { result in
            
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
    
    func testFailureSignUp() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = authorizationService.signUp(credentials: Credentials(
            email: mockModels.email,
            password: mockModels.password)
        ) { result in
            
            if case .failure(let erorr) = result {
                requestResult = false
                requestError = erorr
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
