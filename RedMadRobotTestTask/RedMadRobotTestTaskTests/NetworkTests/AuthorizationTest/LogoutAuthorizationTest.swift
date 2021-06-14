//
//  LogoutAuthorizationTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 06.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class LogoutAuthorizationTest: XCTestCase {
    
    // MARK: - Properties
    
    private var client: MockClient<LogoutEndpoint>!
    private var authorizationService: AuthorizationService!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<LogoutEndpoint>()
        authorizationService = AuthorizationServiceImpl(
            apiClient: client,
            dataInRamManager: MockTokenManager(),
            keychainManager: MockKeychainManager()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        authorizationService = nil
    }
    
    // MARK: - Methods
    
    func testLogout() {
        let requestExpectation = expectation(description: #function)
        
        client.result = .success(())
        
        _ = authorizationService.logout {
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
}
