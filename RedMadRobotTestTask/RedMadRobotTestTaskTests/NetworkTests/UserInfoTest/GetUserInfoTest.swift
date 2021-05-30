//
//  GetUserInfoTest.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 07.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

@testable import RedMadRobotTestTaskAPI

final class GetUserInfoTest: XCTestCase {

    // MARK: - Properties
    
    private var client: MockClient<GetUserInfoEndpoint>!
    private var userInfoService: UserInfoServiceProtocol!
    
    private var mockModels = AuthMockModels()
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        client = MockClient<GetUserInfoEndpoint>()
        userInfoService = UserInfoService(apiClient: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        userInfoService = nil
    }
    
    // MARK: - Methods

    func testSuccessGetUserInfo() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestData: RedMadRobotTestTask.UserInformation?
        
        client.result = .success(mockModels.userStub)
        
        _ = userInfoService.getUserInfo { result in
            
            if case .success(let data) = result {
                requestResult = true
                requestData = data
            }
            
            requestExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertEqual(requestResult, true)
            XCTAssertEqual(requestData, RedMadRobotTestTask.UserInformation(self.mockModels.userStub))
            XCTAssertEqual(self.client.requestCalled, true)
            XCTAssertEqual(self.client.requestCallCount, 1)
        }
    }
    
    func testFailureGetUserInfo() {
        let requestExpectation = expectation(description: #function)
        
        var requestResult: Bool?
        var requestError: Error?
        var requestData: RedMadRobotTestTask.UserInformation?
        
        client.result = .failure(MockWarnings.mockError)
        
        _ = userInfoService.getUserInfo { result in
            
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
