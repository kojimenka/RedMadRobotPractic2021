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

    private var cityValidator: Validator!

    // MARK: - XCTest

    override func setUp() {
        super.setUp()
        cityValidator = CityValidator()
    }

    override func tearDown() {
        super.tearDown()
        cityValidator = nil
    }

    // MARK: - Methods
    
    func testIsCityEmpty() {
        let validValue: String = ""

        do {
            _ = try cityValidator.isValid(value: validValue)
            XCTFail("City validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? CityValidatorError,
                CityValidatorError.emptyCity
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                CityValidatorError.emptyCity.localizedDescription
            )
        }
    }

    func testIsCityToShort() {
        let validValue = "Foo"
        do {
            _ = try cityValidator.isValid(value: validValue)
            XCTFail("City validator doesn't work")
        } catch let error {
            XCTAssertEqual(
                error as? CityValidatorError,
                CityValidatorError.toShortCityName
            )
            
            XCTAssertEqual(
                error.localizedDescription,
                CityValidatorError.toShortCityName.localizedDescription
            )
        }
    }

    func testSuccessFillCity() {
        let validValue = "Bryansk"

        do {
            let validationResult = try cityValidator.isValid(value: validValue)
            XCTAssertEqual(validationResult, true)
        } catch _ {
            XCTFail("City validator doesn't work")
        }
    }

}
