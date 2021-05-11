//
//  TestLoginCoordinator.swift
//  RedMadRobotTestTaskTests
//
//  Created by Дмитрий Марченков on 10.05.2021.
//

import XCTest

@testable import RedMadRobotTestTask

final class TestLoginCoordinator: XCTestCase {
    
    // MARK: - Properties
    
    private var loginCoordinator: LoginCoordinator!
    
    // MARK: - XCTest
    
    override func setUp() {
        super.setUp()
        loginCoordinator = LoginCoordinator(navigationController: UINavigationController())
    }

    override func tearDown() {
        super.tearDown()
        loginCoordinator = nil
    }
    
    // MARK: - Methods
    
    func testStartCoordinator() {
        loginCoordinator.start()
        
        let initialScreen = loginCoordinator.navigationController.topViewController
        
        XCTAssertEqual(initialScreen is LoginScreenVC, true)
    }
    
    // MARK: - Sign In Flow
    
    func testPushSignInCoordinator() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushSignInFromLogin()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignInVC, true)
        }
        
    }

    func testFullSignInFlow() {
        let testExpectation = expectation(description: #function)

        loginCoordinator.start()
        loginCoordinator.pushSignInFromLogin()
        loginCoordinator.pushSuccessScreenFromSignIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SuccessLoginScreenVC, true)
        }
        
    }
    
    func testPushSignUpFromSignIn() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushSignInFromLogin()
        loginCoordinator.pushSignUpFromSignIn()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignUpContainerVC, true)
        }
    }
    
    // MARK: - Sign Up Flow
    
    func testPushSignUpCoordinator() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushSignUpFromLogin()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignUpContainerVC, true)
        }
        
    }

    func testFullSignUpFlow() {
        let testExpectation = expectation(description: #function)

        loginCoordinator.start()
        loginCoordinator.pushSignUpFromLogin()
        loginCoordinator.pushSuccessScreenFromSignUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SuccessLoginScreenVC, true)
        }
        
    }
    
    func testPushSignInFromSignUp() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushSignUpFromLogin()
        loginCoordinator.pushSignInFromSignUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignInVC, true)
        }
    }
    
}
