//
//  MockJubileeReports.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Mock jubilee reports for development
//

import Foundation

extension JubileeReport {

    // MARK: - Mock Data

    static var mockReports: [JubileeReport] {
        [
            // Recent full jubilee report
            JubileeReport(
                reportType: .fullJubilee,
                latitude: 30.4866,
                longitude: -87.9249,
                locationName: "Point Clear",
                species: ["Blue Crab", "Flounder", "Shrimp"],
                intensity: .heavy,
                reportDescription: "Massive jubilee event! Hundreds of crabs and flounder all along the shore. Best I've seen in 5 years!",
                photoURLs: [],
                verifications: 12,
                isVerified: true,
                reportedAt: Date().addingTimeInterval(-2 * 3600), // 2 hours ago
                author: nil // Will be set when users are implemented
            ),

            // Early warning from this morning
            JubileeReport(
                reportType: .earlyWarning,
                latitude: 30.5051,
                longitude: -87.8964,
                locationName: "Fairhope Pier",
                species: ["Blue Crab"],
                intensity: .low,
                reportDescription: "Seeing some crabs moving toward shore. Could be starting.",
                photoURLs: [],
                verifications: 3,
                isVerified: false,
                reportedAt: Date().addingTimeInterval(-5 * 3600), // 5 hours ago
                author: nil
            ),

            // All clear from yesterday
            JubileeReport(
                reportType: .allClear,
                latitude: 30.5234,
                longitude: -87.8812,
                locationName: "Daphne",
                species: [],
                intensity: .low,
                reportDescription: "Water has pushed back out. Event appears to be over.",
                photoURLs: [],
                verifications: 5,
                isVerified: true,
                reportedAt: Date().addingTimeInterval(-24 * 3600), // 24 hours ago
                author: nil
            ),

            // Moderate jubilee
            JubileeReport(
                reportType: .fullJubilee,
                latitude: 30.4921,
                longitude: -87.9156,
                locationName: "Battles Wharf",
                species: ["Blue Crab", "Mullet", "Flounder"],
                intensity: .moderate,
                reportDescription: "Good amount of activity. Worth coming out if you're nearby.",
                photoURLs: [],
                verifications: 8,
                isVerified: true,
                reportedAt: Date().addingTimeInterval(-6 * 3600), // 6 hours ago
                author: nil
            ),

            // Extreme jubilee (rare)
            JubileeReport(
                reportType: .fullJubilee,
                latitude: 30.4755,
                longitude: -87.9401,
                locationName: "Mullet Point",
                species: ["Blue Crab", "Flounder", "Mullet", "Shrimp", "Eel"],
                intensity: .extreme,
                reportDescription: "EPIC jubilee! Never seen anything like it. Entire shoreline covered. Bring your coolers!",
                photoURLs: [],
                verifications: 25,
                isVerified: true,
                reportedAt: Date().addingTimeInterval(-48 * 3600), // 2 days ago
                author: nil
            )
        ]
    }

    /// Single mock report for testing
    static var mockSingle: JubileeReport {
        JubileeReport(
            reportType: .fullJubilee,
            latitude: 30.4866,
            longitude: -87.9249,
            locationName: "Point Clear",
            species: ["Blue Crab", "Flounder"],
            intensity: .heavy,
            reportDescription: "Massive event in progress!",
            photoURLs: [],
            verifications: 15,
            isVerified: true,
            reportedAt: Date().addingTimeInterval(-1 * 3600),
            author: nil
        )
    }
}
