//
//  AddPostUserServiceTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class AddPostUserServiceTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<AddNewPostEndpoint>!
    private var userInfoService: FeedServiceProtocol!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<AddNewPostEndpoint>()
        userInfoService = FeedService(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        userInfoService = nil
    }
    
    // MARK: - Methods

    func testSuccessAddPost() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: RedMadRobotTestTask.PostInfo?
        
        client.result = .success(mockModels.postStub)
        
        _ = userInfoService.addPost(
            postInfo: RedMadRobotTestTask.PostInfo(mockModels.postStub)
        ) { result in
            
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
            XCTAssertEqual(requestData, RedMadRobotTestTask.PostInfo(self.mockModels.postStub))
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureAddPost() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = userInfoService.addPost(
            postInfo: RedMadRobotTestTask.PostInfo(mockModels.postStub)
        ) { result in
            
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
