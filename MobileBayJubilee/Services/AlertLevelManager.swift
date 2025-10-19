//
//  AlertLevelManager.swift
//  MobileBayJubilee
//
//  Created by Architecture Agent on 2025-10-19.
//  Community alert escalation logic implementing PRD specification
//

import Foundation
import CoreLocation

/// Service responsible for calculating Community Alert Level based on user reports
/// Implements escalation logic independent from Condition Score
final class AlertLevelManager {

    // MARK: - Singleton

    static let shared = AlertLevelManager()

    private init() {}

    // MARK: - Constants

    /// Reputation threshold for verified watcher status
    private let verifiedWatcherThreshold = 70

    /// Time window for counting related reports (30 minutes)
    private let reportTimeWindow: TimeInterval = 30 * 60

    /// Geographic clustering radius (2 miles in meters)
    private let geographicClusterRadius: CLLocationDistance = 2.0 * 1609.34

    // MARK: - Public Methods

    /// Calculate current alert level based on recent reports
    /// - Parameters:
    ///   - reports: All jubilee reports to evaluate (should be pre-filtered to recent)
    ///   - referenceLocation: Optional location to check for geographic clustering
    /// - Returns: Current alert level and supporting metrics
    func calculateAlertLevel(
        from reports: [JubileeReport],
        referenceLocation: CLLocation? = nil
    ) -> AlertLevelResult {

        // Filter reports to last 30 minutes
        let now = Date()
        let recentReports = reports.filter { report in
            now.timeIntervalSince(report.reportedAt) <= reportTimeWindow
        }

        // If no recent reports, status is QUIET
        guard !recentReports.isEmpty else {
            return AlertLevelResult(
                level: .none,
                verifiedWatcherCount: 0,
                totalReportCount: 0,
                fullJubileeReportCount: 0,
                nearbyReportCount: 0,
                primaryReason: "No active reports"
            )
        }

        // Count verified watchers
        let verifiedWatcherReports = recentReports.filter { report in
            guard let author = report.author else { return false }
            return author.reputation > verifiedWatcherThreshold
        }
        let verifiedWatcherCount = verifiedWatcherReports.count

        // Count full jubilee reports
        let fullJubileeReports = recentReports.filter { $0.reportType == .fullJubilee }
        let fullJubileeCount = fullJubileeReports.count

        // Count verified watchers with full jubilee reports
        let verifiedWatchersWithFullJubilee = fullJubileeReports.filter { report in
            guard let author = report.author else { return false }
            return author.reputation > verifiedWatcherThreshold
        }.count

        // Count nearby reports if reference location provided
        var nearbyCount = 0
        if let refLocation = referenceLocation {
            nearbyCount = recentReports.filter { report in
                let reportLocation = CLLocation(
                    latitude: report.latitude,
                    longitude: report.longitude
                )
                return refLocation.distance(from: reportLocation) <= geographicClusterRadius
            }.count
        }

        // ESCALATION LOGIC (PRD specification)

        // CONFIRMED: 2 verified watchers OR 5 total users report full jubilee
        if verifiedWatchersWithFullJubilee >= 2 {
            return AlertLevelResult(
                level: .confirmed,
                verifiedWatcherCount: verifiedWatcherCount,
                totalReportCount: recentReports.count,
                fullJubileeReportCount: fullJubileeCount,
                nearbyReportCount: nearbyCount,
                primaryReason: "\(verifiedWatchersWithFullJubilee) verified watchers reported full jubilee"
            )
        }

        if fullJubileeCount >= 5 {
            return AlertLevelResult(
                level: .confirmed,
                verifiedWatcherCount: verifiedWatcherCount,
                totalReportCount: recentReports.count,
                fullJubileeReportCount: fullJubileeCount,
                nearbyReportCount: nearbyCount,
                primaryReason: "\(fullJubileeCount) users reported full jubilee"
            )
        }

        // WATCH: 1 verified watcher (any report type) OR 3 any users within 30 min
        if verifiedWatcherCount >= 1 {
            return AlertLevelResult(
                level: .watch,
                verifiedWatcherCount: verifiedWatcherCount,
                totalReportCount: recentReports.count,
                fullJubileeReportCount: fullJubileeCount,
                nearbyReportCount: nearbyCount,
                primaryReason: "Verified watcher reported activity"
            )
        }

        if recentReports.count >= 3 {
            return AlertLevelResult(
                level: .watch,
                verifiedWatcherCount: verifiedWatcherCount,
                totalReportCount: recentReports.count,
                fullJubileeReportCount: fullJubileeCount,
                nearbyReportCount: nearbyCount,
                primaryReason: "\(recentReports.count) users reported activity"
            )
        }

        // QUIET: Reports exist but don't meet escalation thresholds
        return AlertLevelResult(
            level: .none,
            verifiedWatcherCount: verifiedWatcherCount,
            totalReportCount: recentReports.count,
            fullJubileeReportCount: fullJubileeCount,
            nearbyReportCount: nearbyCount,
            primaryReason: "Reports below escalation threshold"
        )
    }

    /// Check if a location has geographic clustering of reports
    /// - Parameters:
    ///   - location: Location to check
    ///   - reports: Recent reports to evaluate
    ///   - minimumClusterSize: Minimum number of nearby reports to constitute a cluster
    /// - Returns: True if location has clustering
    func hasGeographicClustering(
        at location: CLLocation,
        reports: [JubileeReport],
        minimumClusterSize: Int = 2
    ) -> Bool {
        let nearbyReports = reports.filter { report in
            let reportLocation = CLLocation(
                latitude: report.latitude,
                longitude: report.longitude
            )
            return location.distance(from: reportLocation) <= geographicClusterRadius
        }
        return nearbyReports.count >= minimumClusterSize
    }

    /// Check if user qualifies as verified watcher
    /// - Parameter user: User to check
    /// - Returns: True if reputation exceeds threshold
    func isVerifiedWatcher(_ user: User) -> Bool {
        return user.reputation > verifiedWatcherThreshold || user.isVerifiedWatcher
    }

    /// Calculate notification radius based on alert level
    /// - Parameter level: Alert level
    /// - Returns: Radius in meters
    func notificationRadius(for level: AlertLevel) -> CLLocationDistance {
        switch level {
        case .none:
            return 0 // No notifications
        case .watch:
            return 5.0 * 1609.34 // 5 miles for WATCH
        case .confirmed:
            return 999999 // All opted-in users for CONFIRMED
        }
    }
}

// MARK: - Alert Level Result

/// Result of alert level calculation with supporting metrics
struct AlertLevelResult {
    /// Calculated alert level
    let level: AlertLevel

    /// Number of verified watchers who reported
    let verifiedWatcherCount: Int

    /// Total number of reports in time window
    let totalReportCount: Int

    /// Number of full jubilee reports
    let fullJubileeReportCount: Int

    /// Number of reports near reference location (if provided)
    let nearbyReportCount: Int

    /// Human-readable reason for current level
    let primaryReason: String

    /// Formatted summary for UI display
    var summary: String {
        switch level {
        case .none:
            return "Quiet - \(primaryReason)"
        case .watch:
            return "WATCH - \(primaryReason)"
        case .confirmed:
            return "CONFIRMED - \(primaryReason)"
        }
    }
}

// MARK: - Mock Data Generator

extension AlertLevelManager {

    /// Generate mock alert level result for development/testing
    func generateMockAlertResult(level: AlertLevel) -> AlertLevelResult {
        switch level {
        case .none:
            return AlertLevelResult(
                level: .none,
                verifiedWatcherCount: 0,
                totalReportCount: 1,
                fullJubileeReportCount: 0,
                nearbyReportCount: 0,
                primaryReason: "Single unverified report"
            )

        case .watch:
            return AlertLevelResult(
                level: .watch,
                verifiedWatcherCount: 1,
                totalReportCount: 3,
                fullJubileeReportCount: 0,
                nearbyReportCount: 2,
                primaryReason: "Verified watcher reported early warning signs"
            )

        case .confirmed:
            return AlertLevelResult(
                level: .confirmed,
                verifiedWatcherCount: 3,
                totalReportCount: 7,
                fullJubileeReportCount: 5,
                nearbyReportCount: 4,
                primaryReason: "5 users reported full jubilee at Point Clear"
            )
        }
    }
}

// MARK: - Report Verification Helpers

extension AlertLevelManager {

    /// Update user reputation based on report verification
    /// - Parameters:
    ///   - user: User who submitted report
    ///   - verified: Whether report was verified by community
    ///   - reportType: Type of report submitted
    func updateReputationForReport(
        user: User,
        verified: Bool,
        reportType: ReportType
    ) {
        // Points awarded/deducted based on report type and verification
        let basePoints: Int
        switch reportType {
        case .fullJubilee:
            basePoints = verified ? 5 : -3 // High stakes
        case .earlyWarning:
            basePoints = verified ? 3 : -1 // Medium stakes
        case .allClear:
            basePoints = verified ? 1 : -1 // Lower stakes
        }

        // Update reputation (capped at 0-100)
        user.reputation = max(0, min(100, user.reputation + basePoints))

        // Grant verified watcher status at 75+ reputation
        if user.reputation >= 75 {
            user.isVerifiedWatcher = true
        }
    }

    /// Check if report should trigger immediate notification
    /// - Parameters:
    ///   - report: Report to evaluate
    ///   - author: User who submitted report
    /// - Returns: True if notification should be sent immediately
    func shouldTriggerImmediateNotification(
        report: JubileeReport,
        author: User
    ) -> Bool {
        // Full jubilee from verified watcher always triggers notification
        if report.reportType == .fullJubilee && isVerifiedWatcher(author) {
            return true
        }

        // Early warning from verified watcher triggers notification
        if report.reportType == .earlyWarning && isVerifiedWatcher(author) {
            return true
        }

        return false
    }
}
