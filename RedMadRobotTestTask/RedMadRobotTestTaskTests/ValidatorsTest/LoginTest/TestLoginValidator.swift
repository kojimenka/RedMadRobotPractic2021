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

    private var loginValidator: Validator!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        loginValidator = LoginValidator()
    }

    override func tearDown() {
        super.tearDown()
        loginValidator = nil
    }
    
    // MARK: - Methods
    
    func testEmptyLogin() {
        let validValue: String = ""
      
        do {
           _ = try loginValidator.isValid(value: validValue)
            XCTFail("Login Validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? LoginValidatorError,
                LoginValidatorError.emptyLogin
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                LoginValidatorError.emptyLogin.localizedDescription
            )
        }
    }
    
    func testLoginIsToShort() {
        let validValue = "FooBar"

        do {
           _ = try loginValidator.isValid(value: validValue)
            XCTFail("Login Validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? LoginValidatorError,
                LoginValidatorError.toShortLogin
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                LoginValidatorError.toShortLogin.localizedDescription
            )
        }
    }
    
    func testLoginIsToLong() {
        let validValue = "FooBar BarBuz FooBar BarBuz FooBar BarBuz"
        
        do {
           _ = try loginValidator.isValid(value: validValue)
            XCTFail("Login Validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? LoginValidatorError,
                LoginValidatorError.toLongLogin
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                LoginValidatorError.toLongLogin.localizedDescription
            )
        }
    }
    
    func testSuccessLoginFill() {
        let validValue = "FooBar12"
        
        do {
            let validateResult = try loginValidator.isValid(value: validValue)
            XCTAssertEqual(validateResult, true)
        } catch _ {
            XCTFail("Login Validation change logic")
        }
    }

}
