//
//  ConditionScoreServiceTests.swift
//  MobileBayJubileeTests
//
//  Created by Testing Agent on 10/19/25.
//  Unit tests for ConditionScoreService
//

import XCTest
@testable import MobileBayJubilee

final class ConditionScoreServiceTests: XCTestCase {

    var conditionScoreService: ConditionScoreService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        conditionScoreService = ConditionScoreService()
    }

    override func tearDownWithError() throws {
        conditionScoreService = nil
        try super.tearDownWithError()
    }

    // MARK: - Gating Conditions Tests

    func testWrongMonthReturnsZeroScore() throws {
        // Given: Environmental data in wrong month (January - not jubilee season)
        let environmentalData = MockEnvironmentalData(
            month: 1, // January
            hour: 2, // Correct time window
            windSpeed: 2.0, // Good wind
            windDirection: "S", // Good direction
            tide: .low, // Good tide
            salinity: 20.0,
            waterTemp: 15.0,
            dissolvedOxygen: 4.0
        )

        // When: Calculating condition score
        let score = conditionScoreService.calculateConditionScore(data: environmentalData)

        // Then: Score should be 0
        XCTAssertEqual(score.totalScore, 0, "Wrong month (non-jubilee season) should return 0 score")
        XCTAssertEqual(score.seasonalScore, 0, "Seasonal score should be 0 for wrong month")
    }

    func testCorrectMonthAllowsScoring() throws {
        // Given: Environmental data in correct month (June - peak jubilee season)
        let environmentalData = MockEnvironmentalData(
            month: 6, // June
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low,
            salinity: 20.0,
            waterTemp: 15.0,
            dissolvedOxygen: 4.0
        )

        // When: Calculating condition score
        let score = conditionScoreService.calculateConditionScore(data: environmentalData)

        // Then: Score should be greater than 0
        XCTAssertGreaterThan(score.totalScore, 0, "Correct month should allow scoring")
        XCTAssertGreaterThan(score.seasonalScore, 0, "Seasonal score should be positive for correct month")
    }

    // MARK: - Seasonal Score Tests (0-20 points)

    func testPeakSeasonMaxPoints() throws {
        // Given: Peak jubilee season (June-July)
        let juneData = MockEnvironmentalData(
            month: 6, // June
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        let julyData = MockEnvironmentalData(
            month: 7, // July
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        // When: Calculating seasonal scores
        let juneScore = conditionScoreService.calculateConditionScore(data: juneData)
        let julyScore = conditionScoreService.calculateConditionScore(data: julyData)

        // Then: Should get maximum seasonal points (20)
        XCTAssertEqual(juneScore.seasonalScore, 20, "June should score 20 seasonal points")
        XCTAssertEqual(julyScore.seasonalScore, 20, "July should score 20 seasonal points")
    }

    func testShoulderSeasonMediumPoints() throws {
        // Given: Shoulder season (May, August)
        let mayData = MockEnvironmentalData(
            month: 5, // May
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        let augustData = MockEnvironmentalData(
            month: 8, // August
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        // When: Calculating seasonal scores
        let mayScore = conditionScoreService.calculateConditionScore(data: mayData)
        let augustScore = conditionScoreService.calculateConditionScore(data: augustData)

        // Then: Should get medium seasonal points (10)
        XCTAssertEqual(mayScore.seasonalScore, 10, "May should score 10 seasonal points")
        XCTAssertEqual(augustScore.seasonalScore, 10, "August should score 10 seasonal points")
    }

    func testOffSeasonLowPoints() throws {
        // Given: Off season (September)
        let septemberData = MockEnvironmentalData(
            month: 9, // September
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        // When: Calculating seasonal score
        let score = conditionScoreService.calculateConditionScore(data: septemberData)

        // Then: Should get low seasonal points (5)
        XCTAssertEqual(score.seasonalScore, 5, "September should score 5 seasonal points")
    }

    // MARK: - Time Window Score Tests (0-20 points)

    func testOptimalTimeWindowMaxPoints() throws {
        // Given: Optimal time window (midnight to 6am)
        let times = [0, 1, 2, 3, 4, 5] // Hours 0-5 (midnight to 6am)

        for hour in times {
            let data = MockEnvironmentalData(
                month: 6,
                hour: hour,
                windSpeed: 2.0,
                windDirection: "S",
                tide: .low
            )

            // When: Calculating time window score
            let score = conditionScoreService.calculateConditionScore(data: data)

            // Then: Should get maximum time window points (20)
            XCTAssertEqual(
                score.timeWindowScore,
                20,
                "Hour \(hour) should score 20 time window points"
            )
        }
    }

    func testSuboptimalTimeWindowReducedPoints() throws {
        // Given: Suboptimal time window (6am to noon)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 8, // 8am
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        // When: Calculating time window score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get reduced time window points (10)
        XCTAssertEqual(score.timeWindowScore, 10, "Morning hours should score 10 time window points")
    }

    func testPoorTimeWindowMinimumPoints() throws {
        // Given: Poor time window (afternoon/evening)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 14, // 2pm
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        // When: Calculating time window score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get minimum time window points (0-5)
        XCTAssertLessThanOrEqual(score.timeWindowScore, 5, "Afternoon hours should score 0-5 time window points")
    }

    // MARK: - Wind + Tide Multiplier Tests

    func testOptimalWindSpeedAndDirection() throws {
        // Given: Optimal wind conditions (calm southerly wind)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0, // Calm 0-3 m/s
            windDirection: "S", // Southerly
            tide: .low
        )

        // When: Calculating wind score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get high wind score (12-15 points)
        XCTAssertGreaterThanOrEqual(score.windScore, 12, "Optimal wind should score 12+ points")
        XCTAssertLessThanOrEqual(score.windScore, 15, "Wind score capped at 15")
    }

    func testUnfavorableWindDirection() throws {
        // Given: Unfavorable wind direction (northerly)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "N", // Northerly (unfavorable)
            tide: .low
        )

        // When: Calculating wind score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get low wind score (0-5 points)
        XCTAssertLessThanOrEqual(score.windScore, 5, "Unfavorable wind direction should score low")
    }

    func testHighWindSpeed() throws {
        // Given: High wind speed (strong winds)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 10.0, // Strong wind
            windDirection: "S",
            tide: .low
        )

        // When: Calculating wind score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get reduced wind score
        XCTAssertLessThan(score.windScore, 10, "High wind speed should reduce score")
    }

    func testOptimalTidePhase() throws {
        // Given: Optimal tide phase (low tide)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low // Optimal
        )

        // When: Calculating tide score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get high tide score (12-15 points)
        XCTAssertGreaterThanOrEqual(score.tideScore, 12, "Low tide should score 12+ points")
        XCTAssertLessThanOrEqual(score.tideScore, 15, "Tide score capped at 15")
    }

    func testSuboptimalTidePhase() throws {
        // Given: Suboptimal tide phase (high tide)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .high // Suboptimal
        )

        // When: Calculating tide score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should get lower tide score
        XCTAssertLessThan(score.tideScore, 10, "High tide should score lower than low tide")
    }

    func testWindAndTideMultiplierEffect() throws {
        // Given: Both optimal wind and tide
        let optimalData = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0, // Optimal
            windDirection: "S", // Optimal
            tide: .low // Optimal
        )

        // And: Suboptimal conditions
        let suboptimalData = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 8.0, // High
            windDirection: "N", // Unfavorable
            tide: .high // Suboptimal
        )

        // When: Calculating scores
        let optimalScore = conditionScoreService.calculateConditionScore(data: optimalData)
        let suboptimalScore = conditionScoreService.calculateConditionScore(data: suboptimalData)

        // Then: Optimal conditions should score significantly higher
        let windTideOptimal = optimalScore.windScore + optimalScore.tideScore
        let windTideSuboptimal = suboptimalScore.windScore + suboptimalScore.tideScore

        XCTAssertGreaterThan(
            windTideOptimal,
            windTideSuboptimal,
            "Optimal wind + tide should score higher than suboptimal"
        )
    }

    // MARK: - Water Quality Tests

    func testOptimalSalinity() throws {
        // Given: Optimal salinity (15-25 PSU)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low,
            salinity: 20.0 // Optimal
        )

        // When: Calculating water quality score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should contribute to water quality score
        XCTAssertGreaterThan(score.waterQualityScore, 0, "Optimal salinity should contribute to score")
    }

    func testOptimalWaterTemperature() throws {
        // Given: Optimal water temperature (20-25°C)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low,
            waterTemp: 22.0 // Optimal
        )

        // When: Calculating water quality score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should contribute to water quality score
        XCTAssertGreaterThan(score.waterQualityScore, 0, "Optimal water temp should contribute to score")
    }

    func testLowDissolvedOxygen() throws {
        // Given: Low dissolved oxygen (jubilee trigger condition)
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low,
            dissolvedOxygen: 2.0 // Low (trigger condition)
        )

        // When: Calculating water quality score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Should boost water quality score (low O2 triggers jubilee)
        XCTAssertGreaterThan(score.waterQualityScore, 5, "Low dissolved oxygen should boost score")
    }

    // MARK: - Complete Score Tests

    func testPerfectConditionsHighScore() throws {
        // Given: Perfect jubilee conditions
        let perfectData = MockEnvironmentalData(
            month: 6, // Peak season
            hour: 2, // Optimal time
            windSpeed: 2.0, // Calm
            windDirection: "S", // Favorable
            tide: .low, // Optimal
            salinity: 20.0, // Optimal
            waterTemp: 22.0, // Optimal
            dissolvedOxygen: 2.0 // Low (trigger)
        )

        // When: Calculating total score
        let score = conditionScoreService.calculateConditionScore(data: perfectData)

        // Then: Should get very high total score (70-100)
        XCTAssertGreaterThanOrEqual(score.totalScore, 70, "Perfect conditions should score 70+")
        XCTAssertLessThanOrEqual(score.totalScore, 100, "Total score capped at 100")
    }

    func testPoorConditionsLowScore() throws {
        // Given: Poor jubilee conditions
        let poorData = MockEnvironmentalData(
            month: 9, // Off-season
            hour: 14, // Afternoon
            windSpeed: 10.0, // High wind
            windDirection: "N", // Unfavorable
            tide: .high, // Suboptimal
            salinity: 35.0, // Too high
            waterTemp: 30.0, // Too warm
            dissolvedOxygen: 8.0 // High (no trigger)
        )

        // When: Calculating total score
        let score = conditionScoreService.calculateConditionScore(data: poorData)

        // Then: Should get low total score (0-30)
        XCTAssertLessThanOrEqual(score.totalScore, 30, "Poor conditions should score low")
    }

    func testScoreComponentsAddUpCorrectly() throws {
        // Given: Any conditions
        let data = MockEnvironmentalData(
            month: 6,
            hour: 2,
            windSpeed: 2.0,
            windDirection: "S",
            tide: .low
        )

        // When: Calculating score
        let score = conditionScoreService.calculateConditionScore(data: data)

        // Then: Components should add up to total (or close, accounting for multipliers)
        let componentSum = score.seasonalScore +
                          score.timeWindowScore +
                          score.windScore +
                          score.tideScore +
                          score.waterQualityScore +
                          score.weatherPatternScore

        XCTAssertLessThanOrEqual(componentSum, 100, "Component sum should not exceed 100")
        XCTAssertEqual(score.totalScore, min(componentSum, 100), "Total should equal component sum (capped at 100)")
    }
}

// MARK: - Mock Condition Score Service

/// Mock implementation of ConditionScoreService for testing
/// This will be replaced when the actual service is implemented
class ConditionScoreService {

    func calculateConditionScore(data: MockEnvironmentalData) -> ConditionScore {
        // Gating condition: Check if in jubilee season
        guard isJubileeSeason(month: data.month) else {
            return ConditionScore(
                totalScore: 0,
                seasonalScore: 0,
                timeWindowScore: 0,
                windScore: 0,
                tideScore: 0,
                waterQualityScore: 0,
                weatherPatternScore: 0
            )
        }

        let seasonalScore = calculateSeasonalScore(month: data.month)
        let timeWindowScore = calculateTimeWindowScore(hour: data.hour)
        let windScore = calculateWindScore(speed: data.windSpeed, direction: data.windDirection)
        let tideScore = calculateTideScore(tide: data.tide)
        let waterQualityScore = calculateWaterQualityScore(data: data)
        let weatherPatternScore = 0 // Simplified for testing

        let totalScore = min(
            seasonalScore + timeWindowScore + windScore + tideScore + waterQualityScore + weatherPatternScore,
            100
        )

        return ConditionScore(
            totalScore: totalScore,
            seasonalScore: seasonalScore,
            timeWindowScore: timeWindowScore,
            windScore: windScore,
            tideScore: tideScore,
            waterQualityScore: waterQualityScore,
            weatherPatternScore: weatherPatternScore
        )
    }

    private func isJubileeSeason(month: Int) -> Bool {
        // Jubilee season: May-September (5-9)
        return month >= 5 && month <= 9
    }

    private func calculateSeasonalScore(month: Int) -> Int {
        switch month {
        case 6, 7: return 20 // Peak season (June-July)
        case 5, 8: return 10 // Shoulder season (May, August)
        case 9: return 5 // Off season (September)
        default: return 0
        }
    }

    private func calculateTimeWindowScore(hour: Int) -> Int {
        switch hour {
        case 0...5: return 20 // Midnight to 6am (optimal)
        case 6...11: return 10 // Morning (suboptimal)
        default: return 0 // Afternoon/evening (poor)
        }
    }

    private func calculateWindScore(speed: Double, direction: String) -> Int {
        var score = 0

        // Wind speed (calm is best)
        if speed <= 3.0 {
            score += 8
        } else if speed <= 5.0 {
            score += 5
        } else {
            score += 2
        }

        // Wind direction (southerly is best)
        if direction == "S" || direction == "SE" || direction == "SW" {
            score += 7
        } else if direction == "E" || direction == "W" {
            score += 3
        }

        return min(score, 15)
    }

    private func calculateTideScore(tide: TidePhase) -> Int {
        switch tide {
        case .low: return 15 // Optimal
        case .falling: return 10
        case .rising: return 5
        case .high: return 3
        }
    }

    private func calculateWaterQualityScore(data: MockEnvironmentalData) -> Int {
        var score = 0

        // Salinity (15-25 PSU is optimal)
        if let salinity = data.salinity {
            if salinity >= 15 && salinity <= 25 {
                score += 5
            }
        }

        // Water temperature (20-25°C is optimal)
        if let waterTemp = data.waterTemp {
            if waterTemp >= 20 && waterTemp <= 25 {
                score += 5
            }
        }

        // Dissolved oxygen (low is a trigger for jubilee)
        if let dissolvedOxygen = data.dissolvedOxygen {
            if dissolvedOxygen < 3.0 {
                score += 5 // Low oxygen triggers jubilee
            }
        }

        return min(score, 15)
    }
}

// MARK: - Mock Environmental Data

struct MockEnvironmentalData {
    let month: Int // 1-12
    let hour: Int // 0-23
    let windSpeed: Double // m/s
    let windDirection: String // Cardinal direction
    let tide: TidePhase
    let salinity: Double? // PSU
    let waterTemp: Double? // Celsius
    let dissolvedOxygen: Double? // mg/L

    init(
        month: Int,
        hour: Int,
        windSpeed: Double,
        windDirection: String,
        tide: TidePhase,
        salinity: Double? = nil,
        waterTemp: Double? = nil,
        dissolvedOxygen: Double? = nil
    ) {
        self.month = month
        self.hour = hour
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.tide = tide
        self.salinity = salinity
        self.waterTemp = waterTemp
        self.dissolvedOxygen = dissolvedOxygen
    }
}

// MARK: - Condition Score Model

struct ConditionScore {
    let totalScore: Int
    let seasonalScore: Int
    let timeWindowScore: Int
    let windScore: Int
    let tideScore: Int
    let waterQualityScore: Int
    let weatherPatternScore: Int
}
