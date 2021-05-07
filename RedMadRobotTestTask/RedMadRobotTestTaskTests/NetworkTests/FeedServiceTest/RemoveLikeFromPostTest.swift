//
//  RemoveLikeFromPostTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class RemoveLikeFromPostTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<AddLikeToPostEndpoint>!
    private var feedService: FeedServiceProtocol!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<AddLikeToPostEndpoint>()
        feedService = FeedService(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        feedService = nil
    }
    
    // MARK: - Methods

    func testSuccessRemoveLikeFromPost() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        
        client.result = .success(())
        
        _ = feedService.removeLikeFromPost(postID: "FooBar") { result in
            
            switch result {
            case .success:
                requestResult = true
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
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureRemoveLikeFromPost() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = feedService.removeLikeFromPost(postID: "FooBar") { result in
            
            switch result {
            case .success:
                requestResult = true
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
            XCTAssertEqual(requestError?.localizedDescription, MockWarnings.mockError.localizedDescription)
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
}
