//
//  GetFavouritePostsTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class GetFavouritePostsTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<GetFavouritePostsEndpoint>!
    private var feedService: FeedService!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<GetFavouritePostsEndpoint>()
        feedService = FeedServiceImpl(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        feedService = nil
    }
    
    // MARK: - Methods

    func testSuccessGetFavouritePosts() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: [RedMadRobotTestTask.PostInfo]?
        
        client.result = .success(mockModels.postsStubArray)
        
        _ = feedService.getFavouritePosts { result in
            
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
    
    func testFailureGetFavouritePosts() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = feedService.getFavouritePosts { result in
            
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
