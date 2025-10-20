//
//  LocationService.swift
//  MobileBayJubilee
//
//  Created by Code Review Refactor on 2025-10-20.
//  Manages location services with proper delegate pattern
//

import Foundation
import CoreLocation
import Combine

/// Service responsible for managing user location with proper CLLocationManagerDelegate implementation
@MainActor
class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Published Properties

    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var errorMessage: String?

    // MARK: - Private Properties

    private let locationManager = CLLocationManager()

    // MARK: - Singleton

    static let shared = LocationService()

    private override init() {
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // MARK: - Public Methods

    /// Request location permission from the user
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    /// Start updating location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    /// Stop updating location
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    /// Get CLLocation object for distance calculations
    func getCLLocation() -> CLLocation? {
        guard let coordinate = userLocation else { return nil }
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    // MARK: - CLLocationManagerDelegate

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            errorMessage = nil
        case .denied:
            errorMessage = "Location permission denied. Please enable in Settings."
        case .restricted:
            errorMessage = "Location services are restricted."
        case .notDetermined:
            errorMessage = nil
        @unknown default:
            errorMessage = "Unknown location authorization status."
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        userLocation = location.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to get location: \(error.localizedDescription)"
        print("❌ Location error: \(error.localizedDescription)")
    }
}
