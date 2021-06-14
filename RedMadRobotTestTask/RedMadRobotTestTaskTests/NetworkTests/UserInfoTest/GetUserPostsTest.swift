//
//  GetUserPostsTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class GetUserPostsTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<GetUserPostsEndpoint>!
    private var userInfoService: FeedService!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<GetUserPostsEndpoint>()
        userInfoService = FeedServiceImpl(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        userInfoService = nil
    }
    
    // MARK: - Methods

    func testSuccessGetUserPosts() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: [RedMadRobotTestTask.PostInfo]?
        
        client.result = .success(mockModels.postsStubArray)
        
        _ = userInfoService.getUserPosts { result in
            
            switch result {
            case .success(let data):
                requestResult = true
                requestData = data
            case .failure:
                requestResult = false
            }
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertEqual(requestResult, true)
            XCTAssertEqual(requestData, self.mockModels.postsStubArray.map { RedMadRobotTestTask.PostInfo($0) })
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureGetUserPosts() {
        let requestExpectation = expectation(description: #function)

        var requestResult: Bool?
        var requestError: Error?
        var requestData: [RedMadRobotTestTask.PostInfo]?

        client.result = .failure(MockWarnings.mockError)

        _ = userInfoService.getUserPosts { result in

            switch result {
            case .success(let data):
                requestResult = true
                requestData = data
            case .failure(let error):
                requestResult = false
                requestError = error
            }

            requestExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }

            XCTAssertEqual(requestResult, false)
            XCTAssertEqual(requestData, nil)
            XCTAssertEqual(requestError?.localizedDescription, MockWarnings.mockError.localizedDescription)
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
}
