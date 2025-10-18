//
//  Color+Extensions.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Centralized color definitions
//

import SwiftUI

extension Color {
    // MARK: - App Brand Colors

    /// Primary brand color - Jubilee Blue
    static let appPrimary = Color(red: 30/255, green: 64/255, blue: 175/255)

    /// Secondary brand color - Ocean Teal
    static let appSecondary = Color(red: 8/255, green: 145/255, blue: 178/255)

    // MARK: - Condition Score Colors

    /// Critical/Confirmed condition (80-100)
    static let conditionCritical = Color(red: 220/255, green: 38/255, blue: 38/255)

    /// Watch condition (70-79)
    static let conditionWatch = Color(red: 245/255, green: 158/255, blue: 11/255)

    /// Favorable condition (50-69)
    static let conditionFavorable = Color(red: 16/255, green: 185/255, blue: 129/255)

    /// Moderate condition (30-49)
    static let conditionModerate = Color(red: 59/255, green: 130/255, blue: 246/255)

    /// Low condition (0-29)
    static let conditionLow = Color(red: 107/255, green: 114/255, blue: 128/255)

    // MARK: - Report Type Colors

    /// Full Jubilee report type
    static let reportFullJubilee = Color(red: 220/255, green: 38/255, blue: 38/255)

    /// Early Warning report type
    static let reportEarlyWarning = Color(red: 245/255, green: 158/255, blue: 11/255)

    /// All Clear report type
    static let reportAllClear = Color(red: 107/255, green: 114/255, blue: 128/255)

    // MARK: - Intensity Colors

    /// Extreme intensity
    static let intensityExtreme = Color(red: 220/255, green: 38/255, blue: 38/255)

    /// Heavy intensity
    static let intensityHeavy = Color(red: 245/255, green: 158/255, blue: 11/255)

    /// Moderate intensity
    static let intensityModerate = Color(red: 251/255, green: 191/255, blue: 36/255)

    /// Low intensity
    static let intensityLow = Color(red: 107/255, green: 114/255, blue: 128/255)
}
