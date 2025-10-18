//
//  Location.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 2025-10-18.
//  SwiftData model for beach locations, webcams, and monitoring stations
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class Location {
    // MARK: - Properties

    /// Unique identifier
    var id: UUID

    /// Location type
    var locationType: LocationType

    /// Location details
    var name: String
    var locationDescription: String?
    var latitude: Double
    var longitude: Double

    /// Webcam information (if applicable)
    var webcamURL: String?
    var webcamThumbnailURL: String?

    /// Monitoring station information (if applicable)
    var stationID: String?
    var stationSource: String? // "NOAA", "ARCOS", etc.

    /// User favorites count
    var favoritesCount: Int

    /// Metadata
    var createdAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        locationType: LocationType,
        name: String,
        locationDescription: String? = nil,
        latitude: Double,
        longitude: Double,
        webcamURL: String? = nil,
        webcamThumbnailURL: String? = nil,
        stationID: String? = nil,
        stationSource: String? = nil,
        favoritesCount: Int = 0,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.locationType = locationType
        self.name = name
        self.locationDescription = locationDescription
        self.latitude = latitude
        self.longitude = longitude
        self.webcamURL = webcamURL
        self.webcamThumbnailURL = webcamThumbnailURL
        self.stationID = stationID
        self.stationSource = stationSource
        self.favoritesCount = favoritesCount
        self.createdAt = createdAt
    }
}

// MARK: - Location Type

enum LocationType: String, Codable, CaseIterable {
    case beach = "Beach"
    case webcam = "Webcam"
    case monitoringStation = "Monitoring Station"

    var icon: String {
        switch self {
        case .beach: return "umbrella.fill"
        case .webcam: return "video.fill"
        case .monitoringStation: return "sensor.fill"
        }
    }

    var color: String {
        switch self {
        case .beach: return "blue"
        case .webcam: return "purple"
        case .monitoringStation: return "green"
        }
    }
}

// MARK: - Computed Properties

extension Location {
    /// CLLocationCoordinate2D for MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// Is webcam active
    var hasWebcam: Bool {
        webcamURL != nil
    }

    /// Is monitoring station
    var isMonitoringStation: Bool {
        stationID != nil
    }
}

// MARK: - Predefined Locations

extension Location {
    /// Point Clear beach location
    static var pointClear: Location {
        Location(
            locationType: .beach,
            name: "Point Clear",
            locationDescription: "Popular jubilee spot on eastern shore",
            latitude: 30.4866,
            longitude: -87.9249
        )
    }

    /// Fairhope beach location
    static var fairhope: Location {
        Location(
            locationType: .beach,
            name: "Fairhope Pier",
            locationDescription: "Fairhope Municipal Pier area",
            latitude: 30.5235,
            longitude: -87.9024
        )
    }

    /// Daphne beach location
    static var daphne: Location {
        Location(
            locationType: .beach,
            name: "Daphne Public Beach",
            locationDescription: "Daphne waterfront area",
            latitude: 30.6035,
            longitude: -87.9036
        )
    }
}
