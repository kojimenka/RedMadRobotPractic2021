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

    private var emailValidator: Validator!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        emailValidator = EmailValidator()
    }

    override func tearDown() {
        super.tearDown()
        emailValidator = nil
    }
    
    // MARK: - Methods
    
    func testEmptyEmail() throws {
        let validValue: String = ""
        
        do {
           _ = try emailValidator.isValid(value: validValue)
            XCTFail("Email Validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? EmailValidatorError,
                EmailValidatorError.emptyEmail
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                EmailValidatorError.emptyEmail.localizedDescription
            )
        }
    }
    
    func testEmailIsToShort() {
        let validValue = "FooBar"
    
        do {
           _ = try emailValidator.isValid(value: validValue)
            XCTFail("Email Validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? EmailValidatorError,
                EmailValidatorError.toShortEmail
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                EmailValidatorError.toShortEmail.localizedDescription
            )
        }
    }

    func testEmailContainAT() {
        let validValue = "FooBar124"
        
        do {
           _ = try emailValidator.isValid(value: validValue)
            XCTFail("Email Validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? EmailValidatorError,
                EmailValidatorError.emailNotContainAT
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                EmailValidatorError.emailNotContainAT.localizedDescription
            )
        }
    }

    func testSuccessEmailFill() {
        let validValue = "FooBar@gmail.com"
        
        do {
            let validateResult = try emailValidator.isValid(value: validValue)
            XCTAssertEqual(validateResult, true)
        } catch _ {
            XCTFail("Email Validation change logic")
        }
    }
    
}
