//
//  GetUserFriendsTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class GetUserFriendsTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<GetUserFriendsEndpoint>!
    private var userInfoService: UserInfoServiceProtocol!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<GetUserFriendsEndpoint>()
        userInfoService = UserInfoService(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        userInfoService = nil
    }
    
    // MARK: - Methods

    func testSuccessGetUserFriends() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: [RedMadRobotTestTask.UserInformation]?
        
        client.result = .success(mockModels.usersStubArray)
        
        _ = userInfoService.getUserFriends { result in
            
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
    
    func testFailureGetUserFriends() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        var requestData: [RedMadRobotTestTask.UserInformation]?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = userInfoService.getUserFriends { result in
            
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
