//
//  JubileeReport.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 2025-10-18.
//  SwiftData model for jubilee sighting reports
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class JubileeReport {
    // MARK: - Properties

    /// Unique identifier
    var id: UUID

    /// Report type
    var reportType: ReportType

    /// Location information
    var latitude: Double
    var longitude: Double
    var locationName: String

    /// Report details
    var species: [String] // Array of species names
    var intensity: ReportIntensity
    var reportDescription: String?

    /// Photo URLs (Cloud Storage)
    var photoURLs: [String]

    /// Verification status
    var verifications: Int // Net verifications (thumbs up - thumbs down)
    var isVerified: Bool

    /// Timestamps
    var reportedAt: Date
    var createdAt: Date

    // MARK: - Relationships

    /// User who submitted the report
    var author: User?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        reportType: ReportType,
        latitude: Double,
        longitude: Double,
        locationName: String,
        species: [String] = [],
        intensity: ReportIntensity = .moderate,
        reportDescription: String? = nil,
        photoURLs: [String] = [],
        verifications: Int = 0,
        isVerified: Bool = false,
        reportedAt: Date = Date(),
        createdAt: Date = Date(),
        author: User? = nil
    ) {
        self.id = id
        self.reportType = reportType
        self.latitude = latitude
        self.longitude = longitude
        self.locationName = locationName
        self.species = species
        self.intensity = intensity
        self.reportDescription = reportDescription
        self.photoURLs = photoURLs
        self.verifications = verifications
        self.isVerified = isVerified
        self.reportedAt = reportedAt
        self.createdAt = createdAt
        self.author = author
    }
}

// MARK: - Report Type

enum ReportType: String, Codable, CaseIterable {
    case fullJubilee = "Full Jubilee"
    case earlyWarning = "Early Warning"
    case allClear = "All Clear"

    var icon: String {
        switch self {
        case .fullJubilee: return "exclamationmark.triangle.fill"
        case .earlyWarning: return "eye.fill"
        case .allClear: return "checkmark.circle.fill"
        }
    }

    var color: String {
        switch self {
        case .fullJubilee: return "red"
        case .earlyWarning: return "orange"
        case .allClear: return "green"
        }
    }
}

// MARK: - Report Intensity

enum ReportIntensity: String, Codable, CaseIterable {
    case low = "Light"
    case moderate = "Moderate"
    case heavy = "Heavy"
    case extreme = "Extreme"

    var value: Int {
        switch self {
        case .low: return 1
        case .moderate: return 2
        case .heavy: return 3
        case .extreme: return 4
        }
    }
}

// MARK: - Computed Properties

extension JubileeReport {
    /// CLLocationCoordinate2D for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Time since report was created
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: reportedAt, relativeTo: Date())
    }

    /// Verification status indicator
    var verificationStatus: VerificationStatus {
        if verifications >= 5 {
            return .highlyTrusted
        } else if verifications >= 2 {
            return .trusted
        } else if verifications >= 0 {
            return .unverified
        } else {
            return .disputed
        }
    }
}

// MARK: - Verification Status

enum VerificationStatus: String {
    case disputed = "Disputed"
    case unverified = "Unverified"
    case trusted = "Trusted"
    case highlyTrusted = "Highly Trusted"

    var icon: String {
        switch self {
        case .disputed: return "xmark.circle"
        case .unverified: return "questionmark.circle"
        case .trusted: return "checkmark.circle"
        case .highlyTrusted: return "checkmark.seal.fill"
        }
    }
}
