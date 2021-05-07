//
//  TestNameValidator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 02.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestNameValidator: XCTestCase {
    
    // MARK: - Properties
    
    private var nameValidator: Validator!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        nameValidator = NameValidator()
    }

    override func tearDown() {
        super.tearDown()
        nameValidator = nil
    }
    
    // MARK: - Methods
    
    func testIsNameEmpty() {
        let validValue: String = ""
        
        do {
            _ = try nameValidator.isValid(value: validValue)
            XCTFail("Name validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? NameValidatorError,
                NameValidatorError.emptyName
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                NameValidatorError.emptyName.localizedDescription
            )
        }
    }
    
    func testIsNameToShort() {
        let validValue = "F"
        
        do {
            _ = try nameValidator.isValid(value: validValue)
            XCTFail("Name validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? NameValidatorError,
                NameValidatorError.toShortName
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                NameValidatorError.toShortName.localizedDescription
            )
        }
    }
    
    func testSuccessFillName() {
        let validValue = "Dima"
        
        do {
            let validationResult = try nameValidator.isValid(value: validValue)
            XCTAssertEqual(validationResult, true)
        } catch _ {
            XCTFail("Name validator doesn't work")
        }
    }
    
}
