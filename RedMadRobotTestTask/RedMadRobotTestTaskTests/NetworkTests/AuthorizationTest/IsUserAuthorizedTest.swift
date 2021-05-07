//
//  IsUserAuthorizedTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class IsUserAuthorizedTest: XCTestCase {
    
    // MARK: - Properties
    
    private var client: MockClient<LogoutEndpoint>!
    private var storage: UserStorage!
    private var authorizationService: AuthorizationServiceProtocol!

    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<LogoutEndpoint>()
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
    
    func testSuccessAuthorized() {
        storage.accessToken = "1234"
        
        XCTAssertEqual(authorizationService.isAuthorized, true)
    }
    
    func testFailureAuthorized() {
        storage.accessToken = nil
        
        XCTAssertEqual(authorizationService.isAuthorized, false)
    }
}
