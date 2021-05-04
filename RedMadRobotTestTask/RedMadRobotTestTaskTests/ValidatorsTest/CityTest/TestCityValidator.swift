//
//  TestCityValidator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 02.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestCityValidator: XCTestCase {
    
    // MARK: - Properties
    
    private var cityValidator: RegistrationCityValidator!

    // MARK: - XCTest
    
    override func setUpWithError() throws {
        cityValidator = RegistrationCityValidator()
    }

    override func tearDownWithError() throws {
        cityValidator = nil
    }
    
    // MARK: - Methods

    func testIsCityEmpty() {
        let validValue: String = ""
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = cityValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
    func testIsCityToShort() {
        let validValue = "Foo"
        let expectationResult = false
        let validateResult: Bool?
        
        validateResult = cityValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
    func testSuccessFillCity() {
        let validValue = "Bryansk"
        let expectationResult = true
        let validateResult: Bool?
        
        validateResult = cityValidator.isValid(value: validValue)
        
        XCTAssertEqual(expectationResult, validateResult)
    }
    
}
