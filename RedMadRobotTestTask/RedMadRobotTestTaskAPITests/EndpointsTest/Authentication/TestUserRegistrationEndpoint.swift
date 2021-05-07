//
//  TestUserRegistrationEndpoint.swift
//  RedMadRobotTestTaskAPITests
//
//  Created by Дмитрий Марченков on 03.05.2021.
//

import XCTest

@testable import RedMadRobotTestTaskAPI

final class TestUserRegistrationEndpoint: XCTestCase {

    func testMakeRequest() throws {
        let email = "FooBar@gmail.com"
        let password = "FizzBazz"
        
        let endpoint = UserRegistrationEndpoint(
            email: email,
            password: password
        )

        let urlRequest = try endpoint.makeRequest()
      
        assertPOST(urlRequest)
        assertURL(urlRequest, "auth/registration")
        assertHTTPHeaders(urlRequest, [
            "Content-Type": "application/json"
        ])
        
        assertJsonBody(
            urlRequest,
            [
            "email": email,
            "password": password
            ]
        )
    }

}
