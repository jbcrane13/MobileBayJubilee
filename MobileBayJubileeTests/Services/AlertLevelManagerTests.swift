//
//  AlertLevelManagerTests.swift
//  MobileBayJubileeTests
//
//  Created by Testing Agent on 10/19/25.
//  Unit tests for AlertLevelManager service
//

import XCTest
@testable import MobileBayJubilee

final class AlertLevelManagerTests: XCTestCase {

    var alertLevelManager: AlertLevelManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        alertLevelManager = AlertLevelManager()
    }

    override func tearDownWithError() throws {
        alertLevelManager = nil
        try super.tearDownWithError()
    }

    // MARK: - QUIET → WATCH Escalation Tests

    func testQuietToWatchWithOneVerifiedWatcher() throws {
        // Given: Current alert level is QUIET (none)
        let currentLevel: AlertLevel = .none

        // When: 1 verified watcher reports a jubilee
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .earlyWarning)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level escalates to WATCH
        XCTAssertEqual(newAlertLevel, .watch, "1 verified watcher should escalate QUIET → WATCH")
    }

    func testQuietToWatchWithThreeAnyUsers() throws {
        // Given: Current alert level is QUIET (none)
        let currentLevel: AlertLevel = .none

        // When: 3 regular users (non-verified) report a jubilee
        let reports = [
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level escalates to WATCH
        XCTAssertEqual(newAlertLevel, .watch, "3 any users should escalate QUIET → WATCH")
    }

    func testQuietStaysQuietWithTwoRegularUsers() throws {
        // Given: Current alert level is QUIET
        let currentLevel: AlertLevel = .none

        // When: Only 2 regular users report
        let reports = [
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level stays QUIET (none)
        XCTAssertEqual(newAlertLevel, .none, "Only 2 regular users should not trigger escalation")
    }

    func testQuietToWatchWithMixedUsers() throws {
        // Given: Current alert level is QUIET
        let currentLevel: AlertLevel = .none

        // When: 1 verified + 2 regular users report
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level escalates to WATCH (1 verified is enough)
        XCTAssertEqual(newAlertLevel, .watch, "1 verified watcher should trigger escalation regardless of other users")
    }

    // MARK: - WATCH → CONFIRMED Escalation Tests

    func testWatchToConfirmedWithTwoVerifiedWatchers() throws {
        // Given: Current alert level is WATCH
        let currentLevel: AlertLevel = .watch

        // When: 2 verified watchers report a jubilee
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level escalates to CONFIRMED
        XCTAssertEqual(newAlertLevel, .confirmed, "2 verified watchers should escalate WATCH → CONFIRMED")
    }

    func testWatchToConfirmedWithFiveTotalUsers() throws {
        // Given: Current alert level is WATCH
        let currentLevel: AlertLevel = .watch

        // When: 5 total users (any mix) report a jubilee
        let reports = [
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level escalates to CONFIRMED
        XCTAssertEqual(newAlertLevel, .confirmed, "5 total users should escalate WATCH → CONFIRMED")
    }

    func testWatchStaysWatchWithOneVerifiedWatcher() throws {
        // Given: Current alert level is WATCH
        let currentLevel: AlertLevel = .watch

        // When: Only 1 verified watcher reports
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level stays WATCH
        XCTAssertEqual(newAlertLevel, .watch, "Only 1 verified watcher should not escalate to CONFIRMED")
    }

    func testWatchStaysWatchWithFourTotalUsers() throws {
        // Given: Current alert level is WATCH
        let currentLevel: AlertLevel = .watch

        // When: Only 4 total users report
        let reports = [
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: false, reportType: .earlyWarning),
            createMockReport(isVerifiedUser: false, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level stays WATCH
        XCTAssertEqual(newAlertLevel, .watch, "Only 4 total users should not escalate to CONFIRMED")
    }

    // MARK: - De-escalation Tests

    func testConfirmedStaysConfirmedWithContinuedReports() throws {
        // Given: Current alert level is CONFIRMED
        let currentLevel: AlertLevel = .confirmed

        // When: Reports continue
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level stays CONFIRMED
        XCTAssertEqual(newAlertLevel, .confirmed, "CONFIRMED should stay CONFIRMED with ongoing reports")
    }

    func testDeescalationWithAllClearReports() throws {
        // Given: Current alert level is WATCH
        let currentLevel: AlertLevel = .watch

        // When: Multiple "All Clear" reports come in
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .allClear),
            createMockReport(isVerifiedUser: true, reportType: .allClear)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level de-escalates to QUIET (none)
        XCTAssertEqual(newAlertLevel, .none, "All Clear reports should de-escalate alert level")
    }

    // MARK: - Time Window Tests

    func testOnlyRecentReportsCount() throws {
        // Given: Current alert level is QUIET
        let currentLevel: AlertLevel = .none

        // When: 3 reports, but only 2 are recent (within last hour)
        let recentReport1 = createMockReport(
            isVerifiedUser: false,
            reportType: .earlyWarning,
            reportedAt: Date().addingTimeInterval(-30 * 60) // 30 min ago
        )
        let recentReport2 = createMockReport(
            isVerifiedUser: false,
            reportType: .earlyWarning,
            reportedAt: Date().addingTimeInterval(-45 * 60) // 45 min ago
        )
        let oldReport = createMockReport(
            isVerifiedUser: false,
            reportType: .fullJubilee,
            reportedAt: Date().addingTimeInterval(-2 * 60 * 60) // 2 hours ago
        )

        let reports = [recentReport1, recentReport2, oldReport]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports,
            timeWindowMinutes: 60
        )

        // Then: Alert level stays QUIET (only 2 recent reports, need 3)
        XCTAssertEqual(newAlertLevel, .none, "Old reports should not count toward escalation")
    }

    // MARK: - Edge Cases

    func testEmptyReportsArray() throws {
        // Given: Current alert level is WATCH
        let currentLevel: AlertLevel = .watch

        // When: No reports in the array
        let reports: [MockJubileeReport] = []

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level de-escalates to QUIET
        XCTAssertEqual(newAlertLevel, .none, "No reports should de-escalate to QUIET")
    }

    func testDirectQuietToConfirmedNotPossible() throws {
        // Given: Current alert level is QUIET
        let currentLevel: AlertLevel = .none

        // When: Even with enough reports for CONFIRMED
        let reports = [
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee),
            createMockReport(isVerifiedUser: true, reportType: .fullJubilee)
        ]

        let newAlertLevel = alertLevelManager.calculateAlertLevel(
            currentLevel: currentLevel,
            recentReports: reports
        )

        // Then: Alert level goes to WATCH first (not directly to CONFIRMED)
        XCTAssertEqual(newAlertLevel, .watch, "Should escalate step by step: QUIET → WATCH → CONFIRMED")
    }

    // MARK: - Helper Methods

    private func createMockReport(
        isVerifiedUser: Bool,
        reportType: ReportType,
        reportedAt: Date = Date()
    ) -> MockJubileeReport {
        MockJubileeReport(
            reportType: reportType,
            isVerifiedUser: isVerifiedUser,
            reportedAt: reportedAt
        )
    }
}

// MARK: - Mock Alert Level Manager

/// Mock implementation of AlertLevelManager for testing
/// This will be replaced when the actual service is implemented
class AlertLevelManager {

    /// Calculate alert level based on recent reports
    func calculateAlertLevel(
        currentLevel: AlertLevel,
        recentReports: [MockJubileeReport],
        timeWindowMinutes: Int = 60
    ) -> AlertLevel {

        // Filter reports within time window
        let cutoffTime = Date().addingTimeInterval(-Double(timeWindowMinutes * 60))
        let validReports = recentReports.filter { $0.reportedAt >= cutoffTime }

        // Count All Clear reports for de-escalation
        let allClearCount = validReports.filter { $0.reportType == .allClear }.count
        if allClearCount >= 2 {
            return .none
        }

        // Filter only warning/jubilee reports
        let activeReports = validReports.filter { $0.reportType != .allClear }

        // If no active reports, de-escalate to QUIET
        if activeReports.isEmpty {
            return .none
        }

        // Count verified watchers
        let verifiedWatcherCount = activeReports.filter { $0.isVerifiedUser }.count
        let totalReportCount = activeReports.count

        // Escalation logic based on current level
        switch currentLevel {
        case .none: // QUIET
            // QUIET → WATCH: 1 verified watcher OR 3 any users
            if verifiedWatcherCount >= 1 || totalReportCount >= 3 {
                return .watch
            }
            return .none

        case .watch: // WATCH
            // WATCH → CONFIRMED: 2 verified watchers OR 5 total users
            if verifiedWatcherCount >= 2 || totalReportCount >= 5 {
                return .confirmed
            }
            return .watch

        case .confirmed: // CONFIRMED
            // Stay CONFIRMED if there are ongoing reports
            if !activeReports.isEmpty {
                return .confirmed
            }
            return .watch
        }
    }
}

// MARK: - Mock Report Model

/// Simplified report model for testing alert level logic
struct MockJubileeReport {
    let reportType: ReportType
    let isVerifiedUser: Bool
    let reportedAt: Date
}
