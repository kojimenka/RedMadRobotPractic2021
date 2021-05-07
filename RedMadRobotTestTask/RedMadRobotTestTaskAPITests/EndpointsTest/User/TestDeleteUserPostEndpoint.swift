//
//  TestDeleteUserPostEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestDeleteUserPostEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let postID = "FooBar"
        let endpoint = DeleteUserPostEndpoint(idPostForDelete: postID)

        let urlRequest = try endpoint.makeRequest()
      
        assertDELETE(urlRequest)
        XCTAssertNil(urlRequest.httpBody)
        assertURL(urlRequest, "me/posts/\(postID)")
    }

}
