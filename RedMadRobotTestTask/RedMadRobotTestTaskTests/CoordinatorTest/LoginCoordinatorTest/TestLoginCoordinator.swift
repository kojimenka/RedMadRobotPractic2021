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
        
        XCTAssertEqual(initialScreen is RegistrationContainerVC, true)
    }
    
    // MARK: - Sign In Flow
    
    func testPushLoginScreen() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushLoginScreen(subscriber: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is LoginScreenVC, true)
        }
    }
    
    func testPushSignInCoordinator() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushSignIn(subscriber: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignInVC, true)
        }
        
    }
    
    func testPushSignUpFromSignIn() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushLoginScreen(subscriber: nil)
        loginCoordinator.pushSignIn(subscriber: nil)
        loginCoordinator.pushSignUpFromSignIn(subscriber: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignUpContainerVC, true)
        }
    }
    
    func testInfiniteFlow() {
        let testExpectation = expectation(description: #function)
        
        loginCoordinator.start()
        loginCoordinator.pushLoginScreen(subscriber: nil)
        loginCoordinator.pushSignIn(subscriber: nil)
        loginCoordinator.pushSignUpFromSignIn(subscriber: nil)
        loginCoordinator.pushSignInFromSignUp(subscriber: nil)
        
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
        loginCoordinator.pushLoginScreen(subscriber: nil)
        loginCoordinator.pushSignIn(subscriber: nil)
        loginCoordinator.pushSuccessRegistration(subscriber: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SuccessLoginScreenVC, true)
        }
        
    }
    
    // MARK: - Sign Up Flow
    
    func testPushSignUpCoordinator() {
        let testExpectation = expectation(description: #function)

        loginCoordinator.start()
        loginCoordinator.pushLoginScreen(subscriber: nil)
        loginCoordinator.pushSignUp(subscriber: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            testExpectation.fulfill()
        }

        waitForExpectations(timeout: 1.0) { _ in
            let searchScreen = self.loginCoordinator.navigationController.topViewController
            XCTAssertEqual(searchScreen is SignUpContainerVC, true)
        }
        
    }
    
}
