//
//  FirebaseService.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Firebase service abstraction layer
//

import Foundation
import SwiftUI

// MARK: - Firebase Service Protocol

/// Protocol defining Firebase operations
/// Allows for mock implementation during development and real Firebase implementation in production
protocol FirebaseServiceProtocol {
    // MARK: - Condition Data
    func fetchCurrentCondition() async throws -> ConditionData
    func fetchConditionHistory(limit: Int) async throws -> [ConditionData]

    // MARK: - Jubilee Reports
    func fetchRecentReports(limit: Int) async throws -> [JubileeReport]
    func fetchAllReports() async throws -> [JubileeReport]
    func submitReport(_ report: JubileeReport) async throws
    func verifyReport(reportId: UUID) async throws

    // MARK: - User Management
    func fetchCurrentUser() async throws -> User?
    func updateUser(_ user: User) async throws

    // MARK: - Real-time Updates
    func observeConditionUpdates(callback: @escaping (ConditionData) -> Void)
    func observeReportUpdates(callback: @escaping ([JubileeReport]) -> Void)
}

// MARK: - Mock Firebase Service (for development)

/// Mock implementation using local mock data
/// Replace with RealFirebaseService when Firebase project is ready
class MockFirebaseService: FirebaseServiceProtocol {

    // MARK: - Singleton
    static let shared = MockFirebaseService()
    private init() {}

    // MARK: - Condition Data

    func fetchCurrentCondition() async throws -> ConditionData {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return ConditionData.mockCurrent
    }

    func fetchConditionHistory(limit: Int) async throws -> [ConditionData] {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return Array(ConditionData.mockHistory.prefix(limit))
    }

    // MARK: - Jubilee Reports

    func fetchRecentReports(limit: Int) async throws -> [JubileeReport] {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return Array(JubileeReport.mockReports.prefix(limit))
    }

    func fetchAllReports() async throws -> [JubileeReport] {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return JubileeReport.mockReports
    }

    func submitReport(_ report: JubileeReport) async throws {
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        // TODO: In real implementation, save to Firestore
        print("📝 Mock: Report submitted - \(report.reportType.rawValue) at \(report.locationName)")
    }

    func verifyReport(reportId: UUID) async throws {
        try? await Task.sleep(nanoseconds: 500_000_000)
        // TODO: In real implementation, increment verification count in Firestore
        print("✅ Mock: Report verified - \(reportId)")
    }

    // MARK: - User Management

    func fetchCurrentUser() async throws -> User? {
        try? await Task.sleep(nanoseconds: 500_000_000)
        // TODO: Replace with real Firebase Auth user
        return nil
    }

    func updateUser(_ user: User) async throws {
        try? await Task.sleep(nanoseconds: 500_000_000)
        // TODO: In real implementation, update Firestore user document
        print("👤 Mock: User updated - \(user.displayName)")
    }

    // MARK: - Real-time Updates

    func observeConditionUpdates(callback: @escaping (ConditionData) -> Void) {
        // TODO: In real implementation, set up Firestore listener
        // For now, just call callback once with mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(ConditionData.mockCurrent)
        }
    }

    func observeReportUpdates(callback: @escaping ([JubileeReport]) -> Void) {
        // TODO: In real implementation, set up Firestore listener
        // For now, just call callback once with mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(JubileeReport.mockReports)
        }
    }
}

// MARK: - Firebase Service Manager

/// Global access point for Firebase service
/// Switch between mock and real implementation here
class FirebaseServiceManager {
    /// Current service instance (Mock or Real)
    /// Using RealFirebaseService for production Firebase integration
    /// To use mock data for testing, change to: MockFirebaseService.shared
    static let shared: FirebaseServiceProtocol = RealFirebaseService.shared
}

// MARK: - TODO: Real Firebase Service Implementation
/*

 When Firebase project is ready:

 1. Add Firebase SDK via Swift Package Manager:
    - File → Add Package Dependencies
    - URL: https://github.com/firebase/firebase-ios-sdk
    - Products: FirebaseAuth, FirebaseFirestore, FirebaseStorage, FirebaseMessaging

 2. Add GoogleService-Info.plist to project root
    - Download from Firebase Console
    - Add to MobileBayJubilee target

 3. Initialize Firebase in App file:
    import FirebaseCore

    init() {
        FirebaseApp.configure()
    }

 4. Create RealFirebaseService class:

 import FirebaseFirestore
 import FirebaseAuth

 class RealFirebaseService: FirebaseServiceProtocol {
     private let db = Firestore.firestore()

     func fetchCurrentCondition() async throws -> ConditionData {
         let snapshot = try await db.collection("conditions")
             .order(by: "fetchedAt", descending: true)
             .limit(to: 1)
             .getDocuments()

         guard let document = snapshot.documents.first else {
             throw FirebaseError.noData
         }

         return try document.data(as: ConditionData.self)
     }

     // ... implement other methods using Firestore queries
 }

 5. Update FirebaseServiceManager.shared to use RealFirebaseService:
    static let shared: FirebaseServiceProtocol = RealFirebaseService()

 6. Add Codable conformance to models if needed

 7. Update models to use @DocumentID for Firestore IDs

 */

// MARK: - Firebase Error

enum FirebaseError: LocalizedError {
    case noData
    case unauthorized
    case networkError
    case invalidData

    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data available"
        case .unauthorized:
            return "User not authenticated"
        case .networkError:
            return "Network connection failed"
        case .invalidData:
            return "Invalid data format"
        }
    }
}
