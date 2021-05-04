//
//  TestGetSearchedUserEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestGetSearchedUserEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let predicate = "FooBar"
        
        let endpoint = GetSearchedUserEndpoint(predicate: predicate)

        let urlRequest = try endpoint.makeRequest()
      
        assertGET(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "search?user=\(predicate)")
    }

}
