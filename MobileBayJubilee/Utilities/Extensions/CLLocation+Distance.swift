//
//  CLLocation+Distance.swift
//  MobileBayJubilee
//
//  Created by Code Review Refactor on 2025-10-20.
//  Utility extension for location distance calculations
//

import Foundation
import CoreLocation

extension CLLocation {
    /// Calculates distance in miles to another coordinate.
    /// - Parameter coordinate: The destination coordinate
    /// - Returns: Distance in miles
    func distanceInMiles(from coordinate: CLLocationCoordinate2D) -> Double {
        let destinationLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distanceMeters = self.distance(from: destinationLocation)
        return distanceMeters / 1609.34 // Convert meters to miles
    }
}
