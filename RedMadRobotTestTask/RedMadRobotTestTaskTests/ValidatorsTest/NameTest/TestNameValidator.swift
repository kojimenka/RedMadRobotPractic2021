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
    
    private var nameValidator: RegistrationNameValidator!
    
    // MARK: - XCTest

    override func setUpWithError() throws {
        nameValidator = RegistrationNameValidator()
    }

    override func tearDownWithError() throws {
        nameValidator = nil
    }

    // MARK: - Methods
    
    func testIsNameEmpty() {
        
        let validValue: String = ""
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = nameValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }

    func testIsNameToShort() {
        let validValue = "F"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = nameValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
    func testSuccessFillName() {
        let validValue = "Dima"
        let expectationResult = true
        let validateResult: Bool?
        
        validateResult = nameValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
}
