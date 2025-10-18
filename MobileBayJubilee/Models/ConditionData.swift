//
//  ConditionData.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 2025-10-18.
//  SwiftData model for jubilee condition scoring data
//

import Foundation
import SwiftData

@Model
final class ConditionData {
    // MARK: - Properties

    /// Unique identifier
    var id: UUID

    /// Overall Condition Score (0-100)
    var score: Int

    /// Component scores
    var seasonalScore: Int // 0-20
    var timeWindowScore: Int // 0-20
    var windScore: Int // 0-15
    var tideScore: Int // 0-15
    var weatherPatternScore: Int // 0-15
    var waterQualityScore: Int // 0-15

    /// Environmental data (raw values from APIs)
    var windSpeed: Double // m/s
    var windDirection: String // Cardinal direction
    var temperature: Double // Celsius
    var tide: TidePhase
    var nextHighTide: Date?
    var nextLowTide: Date?
    var salinity: Double? // PSU (Practical Salinity Units)
    var waterTemperature: Double? // Celsius
    var dissolvedOxygen: Double? // mg/L

    /// Community alert level
    var alertLevel: AlertLevel

    /// Timestamp
    var fetchedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        score: Int,
        seasonalScore: Int,
        timeWindowScore: Int,
        windScore: Int,
        tideScore: Int,
        weatherPatternScore: Int,
        waterQualityScore: Int,
        windSpeed: Double,
        windDirection: String,
        temperature: Double,
        tide: TidePhase,
        nextHighTide: Date? = nil,
        nextLowTide: Date? = nil,
        salinity: Double? = nil,
        waterTemperature: Double? = nil,
        dissolvedOxygen: Double? = nil,
        alertLevel: AlertLevel = .none,
        fetchedAt: Date = Date()
    ) {
        self.id = id
        self.score = score
        self.seasonalScore = seasonalScore
        self.timeWindowScore = timeWindowScore
        self.windScore = windScore
        self.tideScore = tideScore
        self.weatherPatternScore = weatherPatternScore
        self.waterQualityScore = waterQualityScore
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.temperature = temperature
        self.tide = tide
        self.nextHighTide = nextHighTide
        self.nextLowTide = nextLowTide
        self.salinity = salinity
        self.waterTemperature = waterTemperature
        self.dissolvedOxygen = dissolvedOxygen
        self.alertLevel = alertLevel
        self.fetchedAt = fetchedAt
    }
}

// MARK: - Tide Phase

enum TidePhase: String, Codable, CaseIterable {
    case rising = "Rising"
    case high = "High"
    case falling = "Falling"
    case low = "Low"

    var icon: String {
        switch self {
        case .rising: return "arrow.up.circle.fill"
        case .high: return "arrow.up.to.line.circle.fill"
        case .falling: return "arrow.down.circle.fill"
        case .low: return "arrow.down.to.line.circle.fill"
        }
    }
}

// MARK: - Alert Level

enum AlertLevel: String, Codable {
    case none = "None"
    case watch = "WATCH"
    case confirmed = "CONFIRMED"

    var color: String {
        switch self {
        case .none: return "gray"
        case .watch: return "orange"
        case .confirmed: return "red"
        }
    }

    var icon: String {
        switch self {
        case .none: return "circle"
        case .watch: return "eye.fill"
        case .confirmed: return "exclamationmark.triangle.fill"
        }
    }
}

// MARK: - Computed Properties

extension ConditionData {
    /// Condition level based on score
    var conditionLevel: ConditionLevel {
        switch score {
        case 0..<30:
            return .poor
        case 30..<50:
            return .fair
        case 50..<70:
            return .good
        case 70..<85:
            return .excellent
        default:
            return .exceptional
        }
    }

    /// Color for UI display
    var scoreColor: String {
        switch conditionLevel {
        case .poor: return "red"
        case .fair: return "orange"
        case .good: return "yellow"
        case .excellent: return "green"
        case .exceptional: return "blue"
        }
    }

    /// Data freshness
    var isFresh: Bool {
        Date().timeIntervalSince(fetchedAt) < 900 // Less than 15 minutes old
    }

    /// Formatted timestamp
    var lastUpdatedText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: fetchedAt, relativeTo: Date())
    }
}

// MARK: - Condition Level

enum ConditionLevel: String {
    case poor = "Poor"
    case fair = "Fair"
    case good = "Good"
    case excellent = "Excellent"
    case exceptional = "Exceptional"

    var description: String {
        switch self {
        case .poor:
            return "Jubilee unlikely"
        case .fair:
            return "Low probability"
        case .good:
            return "Possible conditions"
        case .excellent:
            return "Favorable conditions"
        case .exceptional:
            return "Highly favorable!"
        }
    }
}
