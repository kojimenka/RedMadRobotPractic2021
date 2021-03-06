//
//  GetSortedUsersTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class GetSortedUsersTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<GetSearchedUserEndpoint>!
    private var searchService: SearchService!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<GetSearchedUserEndpoint>()
        searchService = SearchServiceImpl(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        searchService = nil
    }
    
    // MARK: - Methods

    func testSuccessGetSortedUsers() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: [RedMadRobotTestTask.UserInformation]?
        
        client.result = .success(mockModels.usersStubArray)
        
        _ = searchService.getSortedUsers(predicate: "FooBar") { result in
            
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
            XCTAssertEqual(requestData, self.mockModels.usersStubArray.map { RedMadRobotTestTask.UserInformation($0) })
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureGetSortedUsers() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = searchService.getSortedUsers(predicate: "FooBar") { result in
            
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
