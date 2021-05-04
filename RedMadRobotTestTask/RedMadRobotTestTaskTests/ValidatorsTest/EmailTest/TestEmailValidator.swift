//
//  TestEmailValidator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 02.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestEmailValidator: XCTestCase {
    
    // MARK: - Properties

    private var emailValidator: RegistrationEmailValidator!
    
    // MARK: - XCTest

    override func setUpWithError() throws {
        emailValidator = RegistrationEmailValidator()
    }
    
    override func tearDownWithError() throws {
        emailValidator = nil
    }
    
    // MARK: - Methods
    
    func testEmptyEmail() {
        
        let validValue: String = ""
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = emailValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
    func testEmailIsToShort() {
        
        let validValue = "FooBar"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = emailValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
    func testEmailContainAT() {
        
        let validValue = "FooBar124"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = emailValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
    func testSuccessEmailFill() {
        
        let validValue = "FooBar@gmail.com"
        let expectationResult = true
        let validateResult: Bool?
        
        validateResult = emailValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
        
    }
    
}
