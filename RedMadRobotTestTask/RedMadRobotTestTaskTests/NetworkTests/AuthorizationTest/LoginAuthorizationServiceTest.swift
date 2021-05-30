//
//  LoginAuthorizationServiceTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class LoginAuthorizationServiceTest: XCTestCase {
    
    // MARK: - Properties
    
    private var client: MockClient<UserLoginEndpoint>!
    private var storage: UserStorage!
    private var authorizationService: AuthorizationServiceProtocol!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<UserLoginEndpoint>()
        storage = MockStorage()
        authorizationService = AuthorizationServices(apiClient: client, storage: storage)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        storage = nil
        authorizationService = nil
    }
    
    // MARK: - Methods
    
    func testSuccessLogin() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        
        client.result = .success(mockModels.tokenData)
        
        _ = authorizationService.signIn(
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
            XCTAssertEqual(self.storage.accessToken, self.mockModels.tokenData.accessToken)
            XCTAssertEqual(self.storage.refreshToken, self.mockModels.tokenData.refreshToken)
        }
    }
    
    func testFailureSignIn() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = authorizationService.signIn(
            credentials: Credentials(
                email: mockModels.email,
                password: mockModels.password)) { result in
            
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
            XCTAssertEqual(self.storage.accessToken, nil)
            XCTAssertEqual(self.storage.refreshToken, nil)
        }

    }
    
}
