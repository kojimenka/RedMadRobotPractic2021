//
//  UserDefaultsStorageTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class LoginTests: XCTestCase {
    
    // MARK: - Properties
    
    private var userDefaults: UserDefaults!
    private var storage: UserDefaultsUserStorage!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        
        storage = UserDefaultsUserStorage(userDefaults: userDefaults)
    }
    
    // MARK: - Methods
    
    func testFillStorage() {
        let accessToken = "Foo"
        let refreshToken = "Bar"
        
        storage.accessToken = accessToken
        storage.refreshToken = refreshToken
        
        XCTAssertEqual(storage.accessToken, accessToken)
        XCTAssertEqual(storage.refreshToken, refreshToken)
    }
    
}
