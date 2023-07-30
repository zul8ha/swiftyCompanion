//
//  AppRouterTests.swift
//  swifty_companionTests
//
//  Created by Zuleykha Pavlichenkova on 30.07.2023.
//  Copyright © 2023 Heidi Merianne. All rights reserved.
//

@testable import swifty_companion
import XCTest

final class AppRouterTests: XCTestCase {
    
    var appRouter: AppRouter!
    var authManager: AuthManagerMock!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        window = UIWindow()
        authManager = AuthManagerMock()
        appRouter = AppRouter(with: authManager)
    }

    override func tearDownWithError() throws {
        window = nil
        authManager = nil
        appRouter = nil
    }
    
    func test_startApp_setsWindowAndRootVC() {
        // Arrange / given
        authManager.stubbedAuthState = .unauthorised
        
        // Act / when
        appRouter.startApp(in: window)
        
        //
        XCTAssertTrue(appRouter.window === window)
        XCTAssertTrue(appRouter.window?.isKeyWindow ?? false)
        XCTAssertTrue(appRouter.window?.rootViewController is UINavigationController)
    }
    
    func test_startApp_whenAccessTokenNil_presentSignInFlow() {
        // Arrange / given
        authManager.stubbedAuthState = .unauthorised
        
        // Act / when
        appRouter.startApp(in: window)
        
        // Assert / then
        XCTAssert(window.rootViewController?.presentedViewController is SignInViewController)
    }
    
    func test_startApp_whenAccessTokenNotNil_pushUserSearchScreen() {
        // Arrange / given
        authManager.stubbedAuthState = .authorised(accessToken: "token")
        
        // Act / when
        appRouter.startApp(in: window)
        
        // Assert / then
        let navigationController = window.rootViewController as! UINavigationController
        XCTAssert(navigationController.viewControllers.first! is UserSearchViewController)
    }
}
