//
//  MockConditionData.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Mock data for development
//

import Foundation

extension ConditionData {

    // MARK: - Mock Data

    /// Current condition data with WATCH alert (score 75)
    static var mockCurrent: ConditionData {
        ConditionData(
            score: 75,
            seasonalScore: 20,
            timeWindowScore: 15,
            windScore: 12,
            tideScore: 18,
            weatherPatternScore: 8,
            waterQualityScore: 2,
            windSpeed: 3.2,
            windDirection: "NNE",
            temperature: 78.5,
            tide: .low,
            salinity: 12.3,
            waterTemperature: 82.1,
            dissolvedOxygen: 6.8,
            alertLevel: .watch,
            nextHighTide: Date().addingTimeInterval(6 * 3600), // 6 hours from now
            nextLowTide: Date().addingTimeInterval(-2 * 3600), // 2 hours ago
            fetchedAt: Date()
        )
    }

    /// High score condition (CONFIRMED alert)
    static var mockHighScore: ConditionData {
        ConditionData(
            score: 87,
            seasonalScore: 20,
            timeWindowScore: 20,
            windScore: 15,
            tideScore: 20,
            weatherPatternScore: 10,
            waterQualityScore: 2,
            windSpeed: 2.1,
            windDirection: "N",
            temperature: 80.2,
            tide: .rising,
            salinity: 10.5,
            waterTemperature: 84.3,
            dissolvedOxygen: 7.2,
            alertLevel: .confirmed,
            nextHighTide: Date().addingTimeInterval(8 * 3600),
            nextLowTide: Date().addingTimeInterval(-1 * 3600),
            fetchedAt: Date()
        )
    }

    /// Low score condition
    static var mockLowScore: ConditionData {
        ConditionData(
            score: 32,
            seasonalScore: 5,
            timeWindowScore: 5,
            windScore: 8,
            tideScore: 6,
            weatherPatternScore: 6,
            waterQualityScore: 2,
            windSpeed: 12.5,
            windDirection: "S",
            temperature: 72.1,
            tide: .high,
            salinity: 28.4,
            waterTemperature: 75.2,
            dissolvedOxygen: 8.1,
            alertLevel: .none,
            nextHighTide: Date().addingTimeInterval(1 * 3600),
            nextLowTide: Date().addingTimeInterval(7 * 3600),
            fetchedAt: Date()
        )
    }

    /// Array of sample historical data
    static var mockHistory: [ConditionData] {
        [
            ConditionData(
                score: 75,
                seasonalScore: 20, timeWindowScore: 15, windScore: 12,
                tideScore: 18, weatherPatternScore: 8, waterQualityScore: 2,
                windSpeed: 3.2, windDirection: "NNE", temperature: 78.5,
                tide: .low, salinity: 12.3, waterTemperature: 82.1,
                dissolvedOxygen: 6.8, alertLevel: .watch,
                nextHighTide: Date(), nextLowTide: Date(),
                fetchedAt: Date()
            ),
            ConditionData(
                score: 68,
                seasonalScore: 18, timeWindowScore: 12, windScore: 10,
                tideScore: 16, weatherPatternScore: 10, waterQualityScore: 2,
                windSpeed: 4.5, windDirection: "NE", temperature: 77.2,
                tide: .falling, salinity: 14.1, waterTemperature: 81.3,
                dissolvedOxygen: 6.5, alertLevel: .none,
                nextHighTide: Date(), nextLowTide: Date(),
                fetchedAt: Date().addingTimeInterval(-1800) // 30 min ago
            ),
            ConditionData(
                score: 45,
                seasonalScore: 12, timeWindowScore: 8, windScore: 8,
                tideScore: 10, weatherPatternScore: 5, waterQualityScore: 2,
                windSpeed: 8.3, windDirection: "E", temperature: 75.8,
                tide: .high, salinity: 22.5, waterTemperature: 79.1,
                dissolvedOxygen: 7.2, alertLevel: .none,
                nextHighTide: Date(), nextLowTide: Date(),
                fetchedAt: Date().addingTimeInterval(-3600) // 1 hour ago
            )
        ]
    }
}
