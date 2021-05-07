//
//  GetFeedTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class GetFeedTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<GetFeedEndpoint>!
    private var feedService: FeedServiceProtocol!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<GetFeedEndpoint>()
        feedService = FeedService(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        feedService = nil
    }
    
    // MARK: - Methods

    func testSuccessGetFeed() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: [PostInfo]?
        
        client.result = .success(mockModels.postsStubArray)
        
        _ = feedService.getFeed { result in
            
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
            XCTAssertEqual(requestData, self.mockModels.postsStubArray)
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureGetFeed() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = feedService.getFeed { result in
            
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
