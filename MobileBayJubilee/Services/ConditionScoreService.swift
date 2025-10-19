//
//  ConditionScoreService.swift
//  MobileBayJubilee
//
//  Created by Architecture Agent on 2025-10-19.
//  Rule-based Condition Score algorithm implementing PRD v2.0 specification
//

import Foundation

/// Service responsible for calculating Condition Scores using rule-based algorithm with gates and multipliers
final class ConditionScoreService {

    // MARK: - Singleton

    static let shared = ConditionScoreService()

    private init() {}

    // MARK: - Public Methods

    /// Calculate Condition Score from environmental data
    /// - Parameters:
    ///   - date: Current date/time to evaluate
    ///   - windSpeed: Wind speed in m/s
    ///   - windDirection: Cardinal wind direction (e.g., "E", "NE", "W", "SW")
    ///   - tide: Current tide phase
    ///   - waterTemperature: Water temperature in Celsius (optional)
    ///   - weatherPattern: Current weather pattern (optional)
    ///   - salinity: Salinity gradient in PSU (optional)
    /// - Returns: ConditionData with full scoring breakdown
    func calculateConditionScore(
        date: Date = Date(),
        windSpeed: Double,
        windDirection: String,
        tide: TidePhase,
        nextHighTide: Date? = nil,
        nextLowTide: Date? = nil,
        waterTemperature: Double? = nil,
        weatherPattern: WeatherPattern? = nil,
        salinity: Double? = nil,
        airTemperature: Double = 28.0
    ) -> ConditionData {

        // MARK: GATING CONDITIONS - Return 0 if any fail

        // Gate 1: Month must be June (6), July (7), August (8), or September (9)
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        guard [6, 7, 8, 9].contains(month) else {
            return createZeroScoreCondition(
                date: date,
                windSpeed: windSpeed,
                windDirection: windDirection,
                tide: tide,
                nextHighTide: nextHighTide,
                nextLowTide: nextLowTide,
                waterTemperature: waterTemperature,
                airTemperature: airTemperature,
                salinity: salinity,
                reason: "Outside jubilee season (June-September)"
            )
        }

        // Gate 2: Time must be between 9 PM (21:00) and 8 AM (08:00)
        let hour = calendar.component(.hour, from: date)
        guard hour >= 21 || hour < 8 else {
            return createZeroScoreCondition(
                date: date,
                windSpeed: windSpeed,
                windDirection: windDirection,
                tide: tide,
                nextHighTide: nextHighTide,
                nextLowTide: nextLowTide,
                waterTemperature: waterTemperature,
                airTemperature: airTemperature,
                salinity: salinity,
                reason: "Outside time window (9 PM - 8 AM)"
            )
        }

        // Gate 3: Wind direction must NOT be West or Southwest
        let normalizedDirection = windDirection.uppercased().trimmingCharacters(in: .whitespaces)
        let forbiddenDirections = ["W", "WEST", "SW", "SOUTHWEST"]
        guard !forbiddenDirections.contains(normalizedDirection) else {
            return createZeroScoreCondition(
                date: date,
                windSpeed: windSpeed,
                windDirection: windDirection,
                tide: tide,
                nextHighTide: nextHighTide,
                nextLowTide: nextLowTide,
                waterTemperature: waterTemperature,
                airTemperature: airTemperature,
                salinity: salinity,
                reason: "Unfavorable wind direction (West/Southwest)"
            )
        }

        // MARK: SCORING COMPONENTS - All gates passed

        // Component 1: Seasonal Alignment (0-20 points)
        let seasonalScore = calculateSeasonalScore(month: month)

        // Component 2: Time Window (0-15 points)
        let timeWindowScore = calculateTimeWindowScore(hour: hour)

        // Component 3: Wind Conditions (0-25 points)
        var windScore = calculateWindScore(speed: windSpeed, direction: normalizedDirection)

        // Component 4: Tide Phase (0-15 points)
        var tideScore = calculateTideScore(tide: tide)

        // Component 5: MULTIPLIER - East/NE wind AND rising tide
        let shouldApplyMultiplier = isEastOrNortheastWind(normalizedDirection) && tide == .rising
        if shouldApplyMultiplier {
            let multipliedTotal = Int(Double(windScore + tideScore) * 1.3)
            let boost = multipliedTotal - (windScore + tideScore)
            windScore = windScore + (boost * windScore) / (windScore + tideScore) // Proportional boost
            tideScore = tideScore + (boost * tideScore) / (windScore + tideScore)
        }

        // Component 6: Water Temperature (0-10 points, optional)
        let waterQualityScore: Int
        if let waterTemp = waterTemperature {
            waterQualityScore = calculateWaterTemperatureScore(temperature: waterTemp)
        } else {
            waterQualityScore = 0
        }

        // Component 7: Weather Pattern (0-10 points)
        let weatherPatternScore = calculateWeatherPatternScore(pattern: weatherPattern)

        // Component 8: Salinity (0-5 points, optional)
        let salinityScore: Int
        if let salinityGradient = salinity {
            salinityScore = calculateSalinityScore(gradient: salinityGradient)
        } else {
            salinityScore = 0
        }

        // TOTAL SCORE: Sum all components, cap at 100
        let totalScore = min(100, seasonalScore + timeWindowScore + windScore + tideScore + waterQualityScore + weatherPatternScore + salinityScore)

        // Create ConditionData result
        return ConditionData(
            score: totalScore,
            seasonalScore: seasonalScore,
            timeWindowScore: timeWindowScore,
            windScore: windScore,
            tideScore: tideScore,
            weatherPatternScore: weatherPatternScore,
            waterQualityScore: waterQualityScore + salinityScore, // Combined for model compatibility
            windSpeed: windSpeed,
            windDirection: windDirection,
            temperature: airTemperature,
            tide: tide,
            nextHighTide: nextHighTide,
            nextLowTide: nextLowTide,
            salinity: salinity,
            waterTemperature: waterTemperature,
            dissolvedOxygen: nil, // Not used in current algorithm
            alertLevel: .none, // Set by AlertLevelManager separately
            fetchedAt: date
        )
    }

    // MARK: - Private Scoring Methods

    /// Calculate seasonal alignment score based on month
    /// June: 10, July: 15, August: 20, September: 12
    private func calculateSeasonalScore(month: Int) -> Int {
        switch month {
        case 6: return 10  // June
        case 7: return 15  // July
        case 8: return 20  // August
        case 9: return 12  // September
        default: return 0
        }
    }

    /// Calculate time window score based on hour
    /// 1:00-4:00 AM: 15 points
    /// 12:00-1:00 AM or 4:00-6:00 AM: 10 points
    /// 9:00 PM-12:00 AM or 6:00-8:00 AM: 5 points
    private func calculateTimeWindowScore(hour: Int) -> Int {
        switch hour {
        case 1, 2, 3: // 1:00-4:00 AM
            return 15
        case 0, 4, 5: // 12:00-1:00 AM or 4:00-6:00 AM
            return 10
        case 21, 22, 23, 6, 7: // 9:00 PM-12:00 AM or 6:00-8:00 AM
            return 5
        default:
            return 0
        }
    }

    /// Calculate wind score based on speed and direction
    /// Direction: East/NE full points, North/SE reduced by 30%
    /// Speed: 1.86-3 m/s = 25pts, 3-5 = 20pts, 5-8 = 15pts, >8 = 5pts
    private func calculateWindScore(speed: Double, direction: String) -> Int {
        // Base score from wind speed
        let baseScore: Int
        switch speed {
        case 1.86..<3.0:
            baseScore = 25
        case 3.0..<5.0:
            baseScore = 20
        case 5.0..<8.0:
            baseScore = 15
        case 8.0...:
            baseScore = 5
        default: // < 1.86 m/s
            baseScore = 5
        }

        // Direction modifier
        let eastOrNortheast = ["E", "EAST", "NE", "NORTHEAST"]
        let northOrSoutheast = ["N", "NORTH", "SE", "SOUTHEAST"]

        if eastOrNortheast.contains(direction) {
            return baseScore // Full points
        } else if northOrSoutheast.contains(direction) {
            return Int(Double(baseScore) * 0.7) // Reduced by 30%
        } else {
            return Int(Double(baseScore) * 0.5) // Other directions half points
        }
    }

    /// Calculate tide score based on phase
    /// Rising: 15, High slack: 10, Falling: 5, Low slack: 3
    private func calculateTideScore(tide: TidePhase) -> Int {
        switch tide {
        case .rising:
            return 15
        case .high:
            return 10
        case .falling:
            return 5
        case .low:
            return 3
        }
    }

    /// Calculate water temperature score
    /// >28°C: 10, 25-28: 8, 22-25: 5, <22: 0
    private func calculateWaterTemperatureScore(temperature: Double) -> Int {
        switch temperature {
        case 28.0...:
            return 10
        case 25.0..<28.0:
            return 8
        case 22.0..<25.0:
            return 5
        default:
            return 0
        }
    }

    /// Calculate weather pattern score
    /// Overcast + rain: 10, Overcast: 7, Clear: 5
    private func calculateWeatherPatternScore(pattern: WeatherPattern?) -> Int {
        guard let pattern = pattern else {
            return 5 // Default to clear if unknown
        }

        switch pattern {
        case .overcastWithRain:
            return 10
        case .overcast:
            return 7
        case .clear:
            return 5
        case .partlyCloudy:
            return 6 // Between overcast and clear
        }
    }

    /// Calculate salinity score
    /// >8 PSU gradient: 5, 4-8: 3, <4: 0
    private func calculateSalinityScore(gradient: Double) -> Int {
        switch gradient {
        case 8.0...:
            return 5
        case 4.0..<8.0:
            return 3
        default:
            return 0
        }
    }

    /// Check if wind direction is East or Northeast
    private func isEastOrNortheastWind(_ direction: String) -> Bool {
        return ["E", "EAST", "NE", "NORTHEAST"].contains(direction)
    }

    /// Create a zero-score condition when gating conditions fail
    private func createZeroScoreCondition(
        date: Date,
        windSpeed: Double,
        windDirection: String,
        tide: TidePhase,
        nextHighTide: Date?,
        nextLowTide: Date?,
        waterTemperature: Double?,
        airTemperature: Double,
        salinity: Double?,
        reason: String
    ) -> ConditionData {
        return ConditionData(
            score: 0,
            seasonalScore: 0,
            timeWindowScore: 0,
            windScore: 0,
            tideScore: 0,
            weatherPatternScore: 0,
            waterQualityScore: 0,
            windSpeed: windSpeed,
            windDirection: windDirection,
            temperature: airTemperature,
            tide: tide,
            nextHighTide: nextHighTide,
            nextLowTide: nextLowTide,
            salinity: salinity,
            waterTemperature: waterTemperature,
            dissolvedOxygen: nil,
            alertLevel: .none,
            fetchedAt: date
        )
    }
}

// MARK: - Weather Pattern Enum

enum WeatherPattern: String, Codable {
    case clear = "Clear"
    case partlyCloudy = "Partly Cloudy"
    case overcast = "Overcast"
    case overcastWithRain = "Overcast with Rain"
}

// MARK: - Mock Data Generator

extension ConditionScoreService {

    /// Generate realistic mock condition data for development/testing
    /// Uses authentic Mobile Bay environmental ranges from research
    func generateMockConditionData(
        favorableConditions: Bool = false,
        date: Date = Date()
    ) -> ConditionData {

        if favorableConditions {
            // Generate highly favorable conditions
            return calculateConditionScore(
                date: createMockDate(hour: 2, month: 8), // 2 AM in August
                windSpeed: 2.5, // Ideal range
                windDirection: "E", // East wind
                tide: .rising, // Rising tide
                nextHighTide: Date().addingTimeInterval(3600 * 2), // 2 hours from now
                nextLowTide: Date().addingTimeInterval(3600 * 8), // 8 hours from now
                waterTemperature: 29.0, // Warm
                weatherPattern: .overcastWithRain,
                salinity: 9.0, // High gradient
                airTemperature: 27.0
            )
        } else {
            // Generate typical monitoring conditions
            return calculateConditionScore(
                date: createMockDate(hour: 23, month: 7), // 11 PM in July
                windSpeed: 4.2,
                windDirection: "SE",
                tide: .falling,
                nextHighTide: Date().addingTimeInterval(3600 * 5),
                nextLowTide: Date().addingTimeInterval(3600 * 1),
                waterTemperature: 26.5,
                weatherPattern: .partlyCloudy,
                salinity: 5.5,
                airTemperature: 25.0
            )
        }
    }

    /// Create a date with specific hour and month for testing
    private func createMockDate(hour: Int, month: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: Date())
        components.month = month
        components.hour = hour
        components.minute = Int.random(in: 0...59)
        return Calendar.current.date(from: components) ?? Date()
    }
}
