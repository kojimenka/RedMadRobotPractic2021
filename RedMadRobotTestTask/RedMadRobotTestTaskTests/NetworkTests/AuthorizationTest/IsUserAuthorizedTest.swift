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
    private var authorizationService: AuthorizationService!

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
    
}
