//
//  TestLoginValidator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 02.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestLoginValidator: XCTestCase {
    
    // MARK: - Properties

    private var loginValidator: RegistrationLoginValidator!
    
    // MARK: - XCTest
    
    override func setUpWithError() throws {
        loginValidator = RegistrationLoginValidator()
    }

    override func tearDownWithError() throws {
        loginValidator = nil
    }
    
    // MARK: - Methods
    
    func testEmptyLogin() {
        
        let validValue: String = ""
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = loginValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
    func testLoginIsToShort() {
        
        let validValue = "FooBar"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = loginValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
    func testLoginIsToLong() {
        
        let validValue = "FooBar BarBuz FooBar BarBuz FooBar BarBuz"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = loginValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
    func testSuccessLoginFill() {
        
        let validValue = "FooBar12"
        let expectationResult = true
        let validateResult: Bool?
        
        validateResult = loginValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }

}
