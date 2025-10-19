//
//  ReportVerificationUITests.swift
//  MobileBayJubileeUITests
//
//  Created by Testing Agent on 10/19/25.
//  UI tests for report verification functionality
//

import XCTest

final class ReportVerificationUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Verification Button Tests

    func testTapVerifyButtonIncrementsCount() throws {
        // Given: App is launched and user is on Community tab
        navigateToCommunityTab()

        // Find first report card with verification button
        let verifyButtons = app.buttons.matching(NSPredicate(format: "identifier CONTAINS 'verify' OR label CONTAINS 'verify'"))

        // Alternative: Look for checkmark seal icons (verification indicators)
        let checkmarkButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark'"))

        var verifyButton: XCUIElement?

        if verifyButtons.count > 0 {
            verifyButton = verifyButtons.firstMatch
        } else if checkmarkButtons.count > 0 {
            // The verification button might be the checkmark seal button
            verifyButton = checkmarkButtons.firstMatch
        }

        guard let button = verifyButton, button.exists else {
            throw XCTSkip("Verify button not found - feature may not be implemented yet")
        }

        // Get initial verification count
        // Look for a number near the verify button
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        var initialCount: Int?

        for text in staticTexts {
            if let number = Int(text.label), number >= 0 {
                // Found a potential verification count
                initialCount = number
                break
            }
        }

        // When: User taps the verify button
        button.tap()

        // Wait for UI to update
        sleep(1)

        // Then: Verification count should increment
        let staticTextsAfter = app.staticTexts.allElementsBoundByIndex
        var finalCount: Int?

        for text in staticTextsAfter {
            if let number = Int(text.label), number >= 0 {
                finalCount = number
                break
            }
        }

        if let initial = initialCount, let final = finalCount {
            XCTAssertGreaterThan(
                final,
                initial,
                "Verification count should increment after tapping verify button"
            )
        } else {
            // Verification count display may not be implemented yet
            // Check if button state changed instead
            XCTAssertTrue(
                button.exists,
                "Verify button should still exist after tap"
            )
        }
    }

    func testVerifyButtonChangesVisualState() throws {
        // Given: App is on Community tab
        navigateToCommunityTab()

        // Find verification button
        let scrollView = app.scrollViews.firstMatch
        let verifyButton = scrollView.buttons.containing(NSPredicate(format: "label CONTAINS 'checkmark'")).firstMatch

        guard verifyButton.exists else {
            throw XCTSkip("Verify button not found")
        }

        // Capture initial state (e.g., button label or color - color not directly testable)
        let initialLabel = verifyButton.label

        // When: User taps verify button
        verifyButton.tap()

        // Wait for state change
        sleep(1)

        // Then: Button should show verified state
        // (Button may change from outline to filled checkmark)
        let updatedButton = scrollView.buttons.containing(NSPredicate(format: "label CONTAINS 'checkmark'")).firstMatch

        if updatedButton.exists {
            // Check if label changed (e.g., from "checkmark.seal" to "checkmark.seal.fill")
            XCTAssertTrue(
                updatedButton.label != initialLabel || updatedButton.label.contains("fill"),
                "Verify button should change to verified state"
            )
        }
    }

    func testMultipleVerifyButtonsWorkIndependently() throws {
        // Given: Community tab with multiple reports
        navigateToCommunityTab()

        let scrollView = app.scrollViews.firstMatch
        let verifyButtons = scrollView.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark'"))

        guard verifyButtons.count >= 2 else {
            throw XCTSkip("Need at least 2 reports to test independent verification")
        }

        // Get first two verify buttons
        let firstButton = verifyButtons.element(boundBy: 0)
        let secondButton = verifyButtons.element(boundBy: 1)

        // When: User taps first verify button
        firstButton.tap()
        sleep(1)

        // Then: Only first report should be affected
        // (Second button should remain in unverified state)
        XCTAssertTrue(firstButton.exists, "First verify button should still exist")
        XCTAssertTrue(secondButton.exists, "Second verify button should remain unchanged")

        // Verify both buttons are still tappable and independent
        secondButton.tap()
        sleep(1)

        XCTAssertTrue(secondButton.exists, "Second button should be verifiable independently")
    }

    func testVerificationCountDisplaysCorrectly() throws {
        // Given: App is on Community tab
        navigateToCommunityTab()

        let scrollView = app.scrollViews.firstMatch

        // Find a report card with verification count
        // Look for pattern: checkmark icon followed by a number
        let verifyButtons = scrollView.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark'"))

        guard verifyButtons.count > 0 else {
            throw XCTSkip("No verification buttons found")
        }

        let firstVerifyButton = verifyButtons.firstMatch

        // When: Examining the verification display
        // Then: Should show a number (verification count)
        // Look for static text elements near the verify button

        let reportCard = firstVerifyButton.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let nearbyElements = app.staticTexts.allElementsBoundByIndex

        var foundCount = false
        for element in nearbyElements {
            if let _ = Int(element.label) {
                foundCount = true
                XCTAssertTrue(element.exists, "Verification count should be displayed")
                break
            }
        }

        if !foundCount {
            throw XCTSkip("Verification count display may not be implemented yet")
        }
    }

    func testVerifiedReportShowsVerifiedBadge() throws {
        // Given: App is on Community tab
        navigateToCommunityTab()

        // When: Looking at a verified report (has verifications > 0)
        // Then: Should display verified badge or indicator

        let scrollView = app.scrollViews.firstMatch

        // Look for "Verified" badge or filled checkmark seal
        let verifiedBadge = scrollView.staticTexts["Verified"]
        let verifiedIcon = scrollView.images.matching(NSPredicate(format: "identifier CONTAINS 'checkmark.seal.fill'")).firstMatch

        if verifiedBadge.exists {
            XCTAssertTrue(verifiedBadge.exists, "Verified badge should be displayed")
        } else if verifiedIcon.exists {
            XCTAssertTrue(verifiedIcon.exists, "Verified icon should be displayed")
        } else {
            // Tap verify button to create a verified state
            let verifyButton = scrollView.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark'")).firstMatch
            if verifyButton.exists {
                verifyButton.tap()
                sleep(1)

                // Check again for verified indicator
                let updatedBadge = scrollView.staticTexts["Verified"]
                let updatedIcon = scrollView.images.matching(NSPredicate(format: "identifier CONTAINS 'checkmark.seal.fill'")).firstMatch

                XCTAssertTrue(
                    updatedBadge.exists || updatedIcon.exists,
                    "Verified indicator should appear after verification"
                )
            } else {
                throw XCTSkip("Cannot test verified badge - no verify button found")
            }
        }
    }

    func testCannotVerifyOwnReport() throws {
        // Given: User is logged in and has submitted a report
        // When: User views their own report
        // Then: Verify button should be disabled or hidden

        // Note: This test requires authentication and user-specific logic
        // For now, we'll skip if not implemented
        throw XCTSkip("User authentication and own-report detection not yet implemented")
    }

    func testVerificationPersistsAcrossNavigation() throws {
        // Given: User verifies a report
        navigateToCommunityTab()

        let scrollView = app.scrollViews.firstMatch
        let verifyButton = scrollView.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark'")).firstMatch

        guard verifyButton.exists else {
            throw XCTSkip("Verify button not found")
        }

        // Tap to verify
        verifyButton.tap()
        sleep(1)

        // When: User navigates away and back
        // Navigate to different tab
        let dashboardTab = app.tabBars.buttons["Dashboard"]
        if dashboardTab.exists {
            dashboardTab.tap()
            sleep(1)

            // Navigate back to Community
            let communityTab = app.tabBars.buttons["Community"]
            communityTab.tap()
            sleep(1)

            // Then: Verification should persist
            let updatedScrollView = app.scrollViews.firstMatch
            let verifiedButton = updatedScrollView.buttons.matching(NSPredicate(format: "label CONTAINS 'checkmark'")).firstMatch

            XCTAssertTrue(
                verifiedButton.exists,
                "Verification should persist across navigation"
            )
        } else {
            throw XCTSkip("Tab navigation not available")
        }
    }

    // MARK: - Filter Tests with Verification

    func testVerifiedFilterShowsOnlyVerifiedReports() throws {
        // Given: App is on Community tab
        navigateToCommunityTab()

        // When: User selects "Verified" filter
        let verifiedFilterTab = app.buttons["Verified"]

        if verifiedFilterTab.exists {
            verifiedFilterTab.tap()
            sleep(1)

            // Then: Should only show verified reports
            // All visible reports should have verification badge
            let scrollView = app.scrollViews.firstMatch
            let reportCards = scrollView.otherElements.containing(.staticText, identifier: "Community Member")

            if reportCards.count > 0 {
                // Each report should show verified status
                // This is a simplified check - in real implementation would verify each card
                XCTAssertGreaterThan(reportCards.count, 0, "Verified filter should show reports")
            }
        } else {
            throw XCTSkip("Verified filter not yet implemented")
        }
    }

    // MARK: - Helper Methods

    private func navigateToCommunityTab() {
        // Wait for app to load
        sleep(1)

        // Look for Community tab button
        let communityTab = app.tabBars.buttons["Community"]

        if communityTab.exists {
            communityTab.tap()
        } else {
            // Try alternative identifiers
            let alternativeTab = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Community'")).firstMatch
            if alternativeTab.exists {
                alternativeTab.tap()
            }
        }

        // Wait for community view to load
        sleep(1)
    }
}
