//
//  SwiftyCompanionUITests.swift
//  swifty_companionUITests
//

import XCTest

final class SwiftyCompanionUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testSignedOutLaunchShowsSignInButton() {
        launchApp(authenticated: false)

        XCTAssertTrue(app.buttons["signIn.button"].waitForExistence(timeout: 3))
    }

    func testAuthenticatedLaunchShowsSearchScreen() {
        launchApp(authenticated: true)

        XCTAssertTrue(app.navigationBars["Search User"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.searchFields["userSearch.searchField"].exists)
        XCTAssertTrue(app.tables["userSearch.resultsTable"].exists)
        XCTAssertTrue(app.buttons["userSearch.logoutButton"].exists)
    }

    func testLogoutReturnsToSignIn() {
        launchApp(authenticated: true)

        let logOutButton = app.buttons["userSearch.logoutButton"]
        XCTAssertTrue(logOutButton.waitForExistence(timeout: 3))
        logOutButton.tap()

        XCTAssertTrue(app.buttons["signIn.button"].waitForExistence(timeout: 3))
    }

    func testSearchFieldAcceptsInput() {
        launchApp(authenticated: true)

        let searchField = app.searchFields["userSearch.searchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 3))
        searchField.tap()
        searchField.typeText("zuleykha")

        XCTAssertEqual(searchField.value as? String, "zuleykha")
    }

    private func launchApp(authenticated: Bool) {
        app = XCUIApplication()
        app.launchArguments = [
            "-ui-testing",
            authenticated ? "-ui-testing-authenticated" : "-ui-testing-signed-out"
        ]
        app.launch()
    }
}
