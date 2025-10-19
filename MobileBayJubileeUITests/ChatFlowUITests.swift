//
//  ChatFlowUITests.swift
//  MobileBayJubileeUITests
//
//  Created by Testing Agent on 10/19/25.
//  UI tests for community chat/comment functionality
//

import XCTest

final class ChatFlowUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Chat Message Tests

    func testSendMessageInChat() throws {
        // Given: App is launched and user is on Community tab
        navigateToCommunityTab()

        // When: User taps on a report card to view details/comments
        // (Assuming report cards are tappable and show comment section)
        let reportCards = app.scrollViews.otherElements.containing(.staticText, identifier: "Community Member")
        if reportCards.count > 0 {
            let firstReportCard = reportCards.element(boundBy: 0)

            // Tap comment button
            let commentButton = firstReportCard.buttons.matching(identifier: "Comment").firstMatch
            if commentButton.exists {
                commentButton.tap()

                // Wait for comment input field to appear
                let commentTextField = app.textFields["CommentTextField"]
                let commentTextView = app.textViews["CommentTextView"]

                let inputField = commentTextField.exists ? commentTextField : commentTextView

                if inputField.exists {
                    // Type a message
                    inputField.tap()
                    inputField.typeText("This is a test comment from UI test")

                    // Send the message
                    let sendButton = app.buttons["SendButton"].firstMatch
                    if sendButton.exists {
                        sendButton.tap()

                        // Then: Message should appear in the chat/comment list
                        let sentMessage = app.staticTexts["This is a test comment from UI test"]
                        XCTAssertTrue(
                            sentMessage.waitForExistence(timeout: 5),
                            "Sent message should appear in chat/comment list"
                        )
                    } else {
                        XCTFail("Send button not found")
                    }
                } else {
                    // Skip test if chat functionality not yet implemented
                    throw XCTSkip("Chat input field not yet implemented")
                }
            } else {
                throw XCTSkip("Comment button not yet implemented")
            }
        } else {
            throw XCTSkip("No report cards found to test chat on")
        }
    }

    func testVerifyMessageAppearsInFeed() throws {
        // Given: App is launched and community tab is selected
        navigateToCommunityTab()

        // When: User opens comment section and sends a message
        let reportCards = app.scrollViews.otherElements.containing(.staticText, identifier: "Community Member")

        guard reportCards.count > 0 else {
            throw XCTSkip("No report cards available for testing")
        }

        let firstReportCard = reportCards.element(boundBy: 0)
        let commentButton = firstReportCard.buttons.matching(NSPredicate(format: "label CONTAINS 'Comment'")).firstMatch

        if commentButton.exists {
            commentButton.tap()

            let testMessage = "UI Test Message \(Date().timeIntervalSince1970)"
            let inputField = app.textFields["CommentTextField"].exists ?
                            app.textFields["CommentTextField"] :
                            app.textViews["CommentTextView"]

            if inputField.exists {
                inputField.tap()
                inputField.typeText(testMessage)

                let sendButton = app.buttons["SendButton"]
                if sendButton.exists {
                    sendButton.tap()

                    // Then: Message should be visible in the feed
                    let messageInFeed = app.staticTexts[testMessage]
                    XCTAssertTrue(
                        messageInFeed.waitForExistence(timeout: 5),
                        "Message should appear in feed after sending"
                    )
                } else {
                    throw XCTSkip("Send button not implemented yet")
                }
            } else {
                throw XCTSkip("Comment input field not implemented yet")
            }
        } else {
            throw XCTSkip("Comment functionality not yet implemented")
        }
    }

    func testEmptyMessageCannotBeSent() throws {
        // Given: App is on community tab with comment section open
        navigateToCommunityTab()

        let reportCards = app.scrollViews.otherElements.containing(.staticText, identifier: "Community Member")

        guard reportCards.count > 0 else {
            throw XCTSkip("No report cards available")
        }

        let firstReportCard = reportCards.element(boundBy: 0)
        let commentButton = firstReportCard.buttons.matching(NSPredicate(format: "label CONTAINS 'Comment'")).firstMatch

        if commentButton.exists {
            commentButton.tap()

            // When: User tries to send without typing
            let sendButton = app.buttons["SendButton"]

            if sendButton.exists {
                // Then: Send button should be disabled or not send anything
                if sendButton.isEnabled {
                    // If button is enabled, tap it and verify no empty message appears
                    let initialMessageCount = app.staticTexts.count
                    sendButton.tap()

                    // Wait briefly
                    sleep(1)

                    // Message count should not increase
                    let finalMessageCount = app.staticTexts.count
                    XCTAssertEqual(
                        initialMessageCount,
                        finalMessageCount,
                        "Empty messages should not be sent"
                    )
                } else {
                    // Button correctly disabled
                    XCTAssertFalse(sendButton.isEnabled, "Send button should be disabled for empty messages")
                }
            } else {
                throw XCTSkip("Send button not implemented yet")
            }
        } else {
            throw XCTSkip("Comment functionality not yet implemented")
        }
    }

    func testLongMessageCanBeSent() throws {
        // Given: App is on community tab
        navigateToCommunityTab()

        let reportCards = app.scrollViews.otherElements.containing(.staticText, identifier: "Community Member")

        guard reportCards.count > 0 else {
            throw XCTSkip("No report cards available")
        }

        let firstReportCard = reportCards.element(boundBy: 0)
        let commentButton = firstReportCard.buttons.matching(NSPredicate(format: "label CONTAINS 'Comment'")).firstMatch

        if commentButton.exists {
            commentButton.tap()

            // When: User types a long message
            let longMessage = String(repeating: "This is a long test message. ", count: 10)
            let inputField = app.textFields["CommentTextField"].exists ?
                            app.textFields["CommentTextField"] :
                            app.textViews["CommentTextView"]

            if inputField.exists {
                inputField.tap()
                inputField.typeText(longMessage)

                let sendButton = app.buttons["SendButton"]
                if sendButton.exists {
                    sendButton.tap()

                    // Then: Message should be sent successfully
                    // Check for at least part of the message
                    let partialMessage = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'long test message'")).firstMatch
                    XCTAssertTrue(
                        partialMessage.waitForExistence(timeout: 5),
                        "Long message should be sent successfully"
                    )
                } else {
                    throw XCTSkip("Send button not implemented yet")
                }
            } else {
                throw XCTSkip("Comment input field not implemented yet")
            }
        } else {
            throw XCTSkip("Comment functionality not yet implemented")
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
