//
//  TestPasswordValidator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 02.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestPasswordValidator: XCTestCase {
    
    // MARK: - Properties
    
    private var passwordValidator: RegistrationPasswordValidator!
    
    // MARK: - XCTest

    override func setUpWithError() throws {
        passwordValidator = RegistrationPasswordValidator()
    }

    override func tearDownWithError() throws {
        passwordValidator = nil
    }
    
    // MARK: - Methods
    
    func testEmptyPassword() {
        
        let validValue: String = ""
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = passwordValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
    func testPasswordIsToShort() {
        
        let validValue = "Foo"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = passwordValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
    func testPasswordHasDigits() {
        
        let validValue = "FooBar"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = passwordValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
    func testSuccessPasswordFill() {
        
        let validValue = "FooBar123"
        let expectationResult = true
        let validateResult: Bool?
        
        validateResult = passwordValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }

}
