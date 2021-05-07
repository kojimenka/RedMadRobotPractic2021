//
//  TestGetSortedPostsEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestGetSortedPostsEndpoint: XCTestCase {
    
    func testMakeRequest() throws {
        let predicate = "FooBar"
        
        let endpoint = GetSortedPostsEndpoint(predicate: predicate)

        let urlRequest = try endpoint.makeRequest()
      
        assertGET(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "search?post=\(predicate)")
    }

}
