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
    
    private var passwordValidator: Validator!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        passwordValidator = PasswordValidator()
    }

    override func tearDown() {
        super.tearDown()
        passwordValidator = nil
    }
    
    // MARK: - Methods
    
    func testEmptyPassword() {
        let validValue: String = ""
        
        do {
            _ = try passwordValidator.isValid(value: validValue)
            XCTFail("Password validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? PasswordValidatorError,
                PasswordValidatorError.emptyPassword)
            
            XCTAssertEqual(
                error.localizedDescription,
                PasswordValidatorError.emptyPassword.localizedDescription
            )
        }
    }
    
    func testPasswordIsToShort() {
        let validValue = "Foo"
        
        do {
            _ = try passwordValidator.isValid(value: validValue)
            XCTFail("Password validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? PasswordValidatorError,
                PasswordValidatorError.toShortPassword)
            
            XCTAssertEqual(
                error.localizedDescription,
                PasswordValidatorError.toShortPassword.localizedDescription
            )
        }
    }
    
    func testPasswordHasDigits() {
        let validValue = "FooBar"
        
        do {
            _ = try passwordValidator.isValid(value: validValue)
            XCTFail("Password validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? PasswordValidatorError,
                PasswordValidatorError.notContainDigits)
            
            XCTAssertEqual(
                error.localizedDescription,
                PasswordValidatorError.notContainDigits.localizedDescription
            )
        }
    }
    
    func testSuccessPasswordFill() {
        let validValue = "FooBar123"
        
        do {
            let validationResult = try passwordValidator.isValid(value: validValue)
            XCTAssertEqual(validationResult, true)
        } catch _ {
            XCTFail("Password validator doesn't work")
        }
    }
    
}
