//
//  MobileBayJubileeUITests.swift
//  MobileBayJubileeUITests
//
//  Created by Claude Dev Workflow
//

import XCTest

final class MobileBayJubileeUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify app launches successfully
        XCTAssertTrue(app.exists)
    }
}
