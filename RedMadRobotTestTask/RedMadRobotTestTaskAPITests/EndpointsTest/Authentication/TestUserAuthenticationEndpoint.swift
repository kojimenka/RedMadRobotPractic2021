//
//  TestUserAuthenticationEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

import Apexy

@testable import RedMadRobotTestTaskAPI

final class TestUserAuthenticationEndpoint: XCTestCase {
    
    func testMakeRequest() throws {
        let email = "FooBar@gmail.com"
        let password = "FizzBazz"
        
        let endpoint = UserLoginEndpoint(
            email: email,
            password: password
        )

        let urlRequest = try endpoint.makeRequest().0
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "auth/login")
        assertHTTPHeaders(urlRequest, [
            "Content-Type": "application/json"
        ])
        
        assertJsonBody(urlRequest, [
            "email": email,
            "password": password
        ])
    }

}
