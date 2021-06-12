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
        authorizationService = AuthorizationServices(
            apiClient: client,
            tokenManager: MockTokenManager(),
            keychainManager: MockKeychainManager()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        storage = nil
        authorizationService = nil
    }
    
}
