//
//  ReputationManagerTests.swift
//  MobileBayJubileeTests
//
//  Created by Testing Agent on 10/19/25.
//  Unit tests for ReputationManager service
//

import XCTest
@testable import MobileBayJubilee

final class ReputationManagerTests: XCTestCase {

    var reputationManager: ReputationManager!
    var testUser: User!

    override func setUpWithError() throws {
        try super.setUpWithError()
        reputationManager = ReputationManager()

        // Create test user with default reputation of 50
        testUser = User(
            displayName: "Test User",
            email: "test@example.com",
            reputation: 50,
            isVerifiedWatcher: false
        )
    }

    override func tearDownWithError() throws {
        reputationManager = nil
        testUser = nil
        try super.tearDownWithError()
    }

    // MARK: - Verification Points Tests

    func testAddFivePointsOnThreeVerifications() throws {
        // Given: User with 50 reputation
        XCTAssertEqual(testUser.reputation, 50)

        // When: User receives 3 verifications on their report
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 3,
            disputeCount: 0,
            moderatorFlagged: false
        )

        // Then: Reputation increases by 5 points
        XCTAssertEqual(updatedReputation, 55, "User should gain +5 points for 3 verifications")
    }

    func testAddTwoPointsOnOneVerification() throws {
        // Given: User with 50 reputation
        XCTAssertEqual(testUser.reputation, 50)

        // When: User receives 1 verification on their report
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 1,
            disputeCount: 0,
            moderatorFlagged: false
        )

        // Then: Reputation increases by 2 points
        XCTAssertEqual(updatedReputation, 52, "User should gain +2 points for 1 verification")
    }

    func testAddTwoPointsOnTwoVerifications() throws {
        // Given: User with 50 reputation
        XCTAssertEqual(testUser.reputation, 50)

        // When: User receives 2 verifications on their report
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 2,
            disputeCount: 0,
            moderatorFlagged: false
        )

        // Then: Reputation increases by 2 points
        XCTAssertEqual(updatedReputation, 52, "User should gain +2 points for 1-2 verifications")
    }

    // MARK: - Dispute Points Tests

    func testSubtractThreePointsOnThreeDisputes() throws {
        // Given: User with 50 reputation
        XCTAssertEqual(testUser.reputation, 50)

        // When: User receives 3 disputes on their report
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 0,
            disputeCount: 3,
            moderatorFlagged: false
        )

        // Then: Reputation decreases by 3 points
        XCTAssertEqual(updatedReputation, 47, "User should lose -3 points for 3 disputes")
    }

    func testSubtractThreePointsOnMoreThanThreeDisputes() throws {
        // Given: User with 50 reputation
        XCTAssertEqual(testUser.reputation, 50)

        // When: User receives 5 disputes on their report
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 0,
            disputeCount: 5,
            moderatorFlagged: false
        )

        // Then: Reputation decreases by 3 points (capped at 3)
        XCTAssertEqual(updatedReputation, 47, "User should lose -3 points maximum for disputes")
    }

    // MARK: - Moderator Flag Tests

    func testSubtractTenPointsOnModeratorFlag() throws {
        // Given: User with 50 reputation
        XCTAssertEqual(testUser.reputation, 50)

        // When: User's report is flagged by a moderator
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 0,
            disputeCount: 0,
            moderatorFlagged: true
        )

        // Then: Reputation decreases by 10 points
        XCTAssertEqual(updatedReputation, 40, "User should lose -10 points for moderator flag")
    }

    func testModeratorFlagOverridesVerifications() throws {
        // Given: User with 50 reputation and 3 verifications
        // When: Report is also flagged by moderator
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: 50,
            verificationCount: 3,
            disputeCount: 0,
            moderatorFlagged: true
        )

        // Then: Moderator flag takes precedence (net: +5 - 10 = -5)
        XCTAssertEqual(updatedReputation, 45, "Moderator flag should apply even with verifications")
    }

    // MARK: - Reputation Cap Tests

    func testReputationCannotExceedOneHundred() throws {
        // Given: User with 98 reputation
        testUser.reputation = 98

        // When: User gains 5 points (would be 103)
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 3,
            disputeCount: 0,
            moderatorFlagged: false
        )

        // Then: Reputation is capped at 100
        XCTAssertEqual(updatedReputation, 100, "Reputation should be capped at 100")
        XCTAssertLessThanOrEqual(updatedReputation, 100, "Reputation must not exceed 100")
    }

    func testReputationCannotGoBelowZero() throws {
        // Given: User with 5 reputation
        testUser.reputation = 5

        // When: User loses 10 points from moderator flag (would be -5)
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 0,
            disputeCount: 0,
            moderatorFlagged: true
        )

        // Then: Reputation is capped at 0
        XCTAssertEqual(updatedReputation, 0, "Reputation should be capped at 0")
        XCTAssertGreaterThanOrEqual(updatedReputation, 0, "Reputation must not go below 0")
    }

    func testReputationStaysAtOneHundredWhenAlreadyMax() throws {
        // Given: User with 100 reputation
        testUser.reputation = 100

        // When: User gains more points
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 3,
            disputeCount: 0,
            moderatorFlagged: false
        )

        // Then: Reputation stays at 100
        XCTAssertEqual(updatedReputation, 100, "Reputation should remain at 100")
    }

    func testReputationStaysAtZeroWhenAlreadyMin() throws {
        // Given: User with 0 reputation
        testUser.reputation = 0

        // When: User loses points
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: testUser.reputation,
            verificationCount: 0,
            disputeCount: 3,
            moderatorFlagged: false
        )

        // Then: Reputation stays at 0
        XCTAssertEqual(updatedReputation, 0, "Reputation should remain at 0")
    }

    // MARK: - Combined Scenarios Tests

    func testCombinedVerificationsAndDisputes() throws {
        // Given: User with 50 reputation
        // When: User has both 3 verifications (+5) and 3 disputes (-3)
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: 50,
            verificationCount: 3,
            disputeCount: 3,
            moderatorFlagged: false
        )

        // Then: Net change is +2 (50 + 5 - 3 = 52)
        XCTAssertEqual(updatedReputation, 52, "Combined effects should be +5 -3 = +2")
    }

    func testAllNegativeScenario() throws {
        // Given: User with 50 reputation
        // When: User has disputes and moderator flag
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: 50,
            verificationCount: 0,
            disputeCount: 3,
            moderatorFlagged: true
        )

        // Then: Total penalty is -13 (50 - 3 - 10 = 37)
        XCTAssertEqual(updatedReputation, 37, "All penalties should stack: -3 -10 = -13")
    }

    // MARK: - Edge Cases

    func testZeroVerificationsZeroDisputes() throws {
        // Given: User with 50 reputation
        // When: No activity
        let updatedReputation = reputationManager.calculateReputationChange(
            currentReputation: 50,
            verificationCount: 0,
            disputeCount: 0,
            moderatorFlagged: false
        )

        // Then: Reputation unchanged
        XCTAssertEqual(updatedReputation, 50, "Reputation should remain unchanged")
    }

    func testVerifiedWatcherPromotion() throws {
        // Given: User with 75+ reputation
        testUser.reputation = 75

        // When: Checking if user qualifies for verified watcher
        let qualifiesForVerifiedWatcher = reputationManager.qualifiesForVerifiedWatcher(reputation: testUser.reputation)

        // Then: User should qualify
        XCTAssertTrue(qualifiesForVerifiedWatcher, "Users with 75+ reputation should qualify for verified watcher status")
    }

    func testVerifiedWatcherNotQualified() throws {
        // Given: User with less than 75 reputation
        testUser.reputation = 74

        // When: Checking if user qualifies for verified watcher
        let qualifiesForVerifiedWatcher = reputationManager.qualifiesForVerifiedWatcher(reputation: testUser.reputation)

        // Then: User should not qualify
        XCTAssertFalse(qualifiesForVerifiedWatcher, "Users with <75 reputation should not qualify for verified watcher status")
    }
}

// MARK: - Mock ReputationManager

/// Mock implementation of ReputationManager for testing
/// This will be replaced when the actual service is implemented
class ReputationManager {

    /// Calculate reputation change based on report activity
    func calculateReputationChange(
        currentReputation: Int,
        verificationCount: Int,
        disputeCount: Int,
        moderatorFlagged: Bool
    ) -> Int {
        var newReputation = currentReputation

        // Add points for verifications
        if verificationCount >= 3 {
            newReputation += 5
        } else if verificationCount >= 1 {
            newReputation += 2
        }

        // Subtract points for disputes (capped at -3)
        if disputeCount >= 3 {
            newReputation -= 3
        }

        // Subtract points for moderator flag
        if moderatorFlagged {
            newReputation -= 10
        }

        // Cap reputation between 0-100
        return min(max(newReputation, 0), 100)
    }

    /// Check if user qualifies for verified watcher status
    func qualifiesForVerifiedWatcher(reputation: Int) -> Bool {
        return reputation >= 75
    }
}
