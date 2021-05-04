//
//  TestGetFavouritePostsEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestGetFavouritePostsEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let endpoint = GetFavouritePostsEndpoint()

        let urlRequest = try endpoint.makeRequest()
      
        assertGET(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "feed/favorite")
    }
    
}
