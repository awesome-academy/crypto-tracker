//
//  CryptoTrackerUITests.swift
//  CryptoTrackerUITests
//
//  Created by Huy Hà on 8/10/22.
//

import XCTest

final class CryptoTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
    }
}
