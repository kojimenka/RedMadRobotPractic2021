//
//  TestAddNewPostEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestAddNewPostEndpoint: XCTestCase {

    func testMakeRequest() throws {
    
        let post = AddPostModel(
            text: nil,
            imageData: nil,
            lon: nil,
            lat: nil
        )
        
        let endpoint = AddNewPostEndpoint(
            postInfo: post
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "me/posts")
    }
    
}
