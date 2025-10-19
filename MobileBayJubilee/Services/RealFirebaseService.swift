//
//  RealFirebaseService.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Real Firebase implementation for production use
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import CryptoKit

// MARK: - Firestore Data Models

/// Firestore-compatible struct for ConditionData
struct FirestoreCondition: Codable {
    var score: Int
    var seasonalScore: Int
    var timeWindowScore: Int
    var windScore: Int
    var tideScore: Int
    var weatherPatternScore: Int
    var waterQualityScore: Int
    var windSpeed: Double
    var windDirection: String
    var temperature: Double
    var tide: String
    var nextHighTide: Date?
    var nextLowTide: Date?
    var salinity: Double?
    var waterTemperature: Double?
    var dissolvedOxygen: Double?
    var alertLevel: String
    var fetchedAt: Date

    /// Convert to SwiftData model
    func toConditionData() -> ConditionData {
        ConditionData(
            score: score,
            seasonalScore: seasonalScore,
            timeWindowScore: timeWindowScore,
            windScore: windScore,
            tideScore: tideScore,
            weatherPatternScore: weatherPatternScore,
            waterQualityScore: waterQualityScore,
            windSpeed: windSpeed,
            windDirection: windDirection,
            temperature: temperature,
            tide: TidePhase(rawValue: tide) ?? .low,
            nextHighTide: nextHighTide,
            nextLowTide: nextLowTide,
            salinity: salinity,
            waterTemperature: waterTemperature,
            dissolvedOxygen: dissolvedOxygen,
            alertLevel: AlertLevel(rawValue: alertLevel) ?? .none,
            fetchedAt: fetchedAt
        )
    }
}

/// Firestore-compatible struct for JubileeReport
struct FirestoreReport: Codable {
    var reportType: String
    var latitude: Double
    var longitude: Double
    var locationName: String
    var intensity: String
    var species: [String]
    var reportDescription: String?
    var reportedAt: Date
    var reportedBy: String // Firebase Auth UID
    var verifications: Int
    var isVerified: Bool
    var photoURLs: [String]
    var createdAt: Date

    /// Convert to SwiftData model
    func toJubileeReport() -> JubileeReport {
        JubileeReport(
            reportType: ReportType(rawValue: reportType) ?? .earlyWarning,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            species: species,
            intensity: ReportIntensity(rawValue: intensity) ?? .moderate,
            reportDescription: reportDescription,
            photoURLs: photoURLs,
            verifications: verifications,
            isVerified: isVerified,
            reportedAt: reportedAt,
            createdAt: createdAt,
            author: nil // Will be populated separately if needed
        )
    }
}

/// Firestore-compatible struct for User
struct FirestoreUser: Codable {
    var displayName: String
    var email: String
    var profilePhotoURL: String?
    var reputation: Int
    var isVerifiedWatcher: Bool
    var favoriteLocations: [String]
    var notificationsEnabled: Bool
    var notificationThreshold: Int
    var createdAt: Date
    var lastLoginAt: Date

    /// Convert to SwiftData model
    func toUser(id: UUID) -> User {
        User(
            id: id,
            displayName: displayName,
            email: email,
            profilePhotoURL: profilePhotoURL,
            reputation: reputation,
            isVerifiedWatcher: isVerifiedWatcher,
            favoriteLocations: favoriteLocations,
            notificationThreshold: notificationThreshold,
            notificationsEnabled: notificationsEnabled,
            createdAt: createdAt,
            lastLoginAt: lastLoginAt
        )
    }
}

// MARK: - Real Firebase Service

class RealFirebaseService: FirebaseServiceProtocol {

    // MARK: - Properties

    private let db = Firestore.firestore()
    private let auth = Auth.auth()

    // MARK: - Singleton

    static let shared = RealFirebaseService()

    private init() {
        // Configure Firestore settings
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        db.settings = settings
    }

    // MARK: - Condition Data

    func fetchCurrentCondition() async throws -> ConditionData {
        let snapshot = try await db.collection("conditions")
            .order(by: "fetchedAt", descending: true)
            .limit(to: 1)
            .getDocuments()

        guard let document = snapshot.documents.first else {
            throw FirebaseError.noData
        }

        let firestoreCondition = try document.data(as: FirestoreCondition.self)
        return firestoreCondition.toConditionData()
    }

    func fetchConditionHistory(limit: Int) async throws -> [ConditionData] {
        let snapshot = try await db.collection("conditions")
            .order(by: "fetchedAt", descending: true)
            .limit(to: limit)
            .getDocuments()

        return try snapshot.documents.compactMap { document in
            let firestoreCondition = try document.data(as: FirestoreCondition.self)
            return firestoreCondition.toConditionData()
        }
    }

    // MARK: - Jubilee Reports

    func fetchRecentReports(limit: Int) async throws -> [JubileeReport] {
        let snapshot = try await db.collection("reports")
            .order(by: "reportedAt", descending: true)
            .limit(to: limit)
            .getDocuments()

        return try snapshot.documents.compactMap { document in
            let firestoreReport = try document.data(as: FirestoreReport.self)
            return firestoreReport.toJubileeReport()
        }
    }

    func fetchAllReports() async throws -> [JubileeReport] {
        let snapshot = try await db.collection("reports")
            .order(by: "reportedAt", descending: true)
            .getDocuments()

        return try snapshot.documents.compactMap { document in
            let firestoreReport = try document.data(as: FirestoreReport.self)
            return firestoreReport.toJubileeReport()
        }
    }

    func submitReport(_ report: JubileeReport) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw FirebaseError.unauthorized
        }

        // Create Firestore-compatible dictionary
        let reportData: [String: Any] = [
            "id": report.id.uuidString, // Store UUID for querying
            "reportType": report.reportType.rawValue,
            "latitude": report.latitude,
            "longitude": report.longitude,
            "locationName": report.locationName,
            "intensity": report.intensity.rawValue,
            "species": report.species,
            "reportDescription": report.reportDescription ?? "",
            "reportedAt": Timestamp(date: report.reportedAt),
            "createdAt": Timestamp(date: report.createdAt),
            "reportedBy": userId,
            "verifications": 0,
            "isVerified": false,
            "photoURLs": report.photoURLs
        ]

        try await db.collection("reports").addDocument(data: reportData)
    }

    func verifyReport(reportId: UUID) async throws {
        guard auth.currentUser != nil else {
            throw FirebaseError.unauthorized
        }

        // Note: In production, you should track which users verified which reports
        // to prevent duplicate verifications

        let reportQuery = try await db.collection("reports")
            .whereField("id", isEqualTo: reportId.uuidString)
            .getDocuments()

        guard let reportDoc = reportQuery.documents.first else {
            throw FirebaseError.noData
        }

        try await reportDoc.reference.updateData([
            "verifications": FieldValue.increment(Int64(1)),
            "isVerified": true // Mark as verified (boolean, not timestamp)
        ])
    }

    // MARK: - User Management

    func fetchCurrentUser() async throws -> User? {
        guard let userId = auth.currentUser?.uid else {
            return nil
        }

        let document = try await db.collection("users").document(userId).getDocument()

        guard document.exists else {
            return nil
        }

        let firestoreUser = try document.data(as: FirestoreUser.self)
        // Firebase UIDs are not UUIDs - we need to generate one
        // Using a hash-based approach for deterministic UUID generation
        let uuidData = userId.data(using: .utf8)!
        let hash = uuidData.withUnsafeBytes { bytes in
            var hasher = SHA256()
            hasher.update(bufferPointer: UnsafeRawBufferPointer(start: bytes.baseAddress, count: bytes.count))
            return hasher.finalize()
        }
        // Take first 16 bytes and create UUID
        let uuidBytes = Array(hash.prefix(16))
        let uuidString = String(format: "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
                               uuidBytes[0], uuidBytes[1], uuidBytes[2], uuidBytes[3],
                               uuidBytes[4], uuidBytes[5],
                               uuidBytes[6], uuidBytes[7],
                               uuidBytes[8], uuidBytes[9],
                               uuidBytes[10], uuidBytes[11], uuidBytes[12], uuidBytes[13], uuidBytes[14], uuidBytes[15])
        let deterministicUUID = UUID(uuidString: uuidString) ?? UUID()
        return firestoreUser.toUser(id: deterministicUUID)
    }

    func updateUser(_ user: User) async throws {
        guard let userId = auth.currentUser?.uid else {
            throw FirebaseError.unauthorized
        }

        let userData: [String: Any] = [
            "displayName": user.displayName,
            "email": user.email,
            "profilePhotoURL": user.profilePhotoURL ?? "",
            "reputation": user.reputation,
            "isVerifiedWatcher": user.isVerifiedWatcher,
            "favoriteLocations": user.favoriteLocations,
            "notificationsEnabled": user.notificationsEnabled,
            "notificationThreshold": user.notificationThreshold,
            "lastLoginAt": Timestamp(date: user.lastLoginAt)
        ]

        try await db.collection("users").document(userId).setData(userData, merge: true)
    }

    // MARK: - Real-time Updates

    func observeConditionUpdates(callback: @escaping (ConditionData) -> Void) {
        db.collection("conditions")
            .order(by: "fetchedAt", descending: true)
            .limit(to: 1)
            .addSnapshotListener { snapshot, error in
                guard let document = snapshot?.documents.first else {
                    print("Error fetching condition updates: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    let firestoreCondition = try document.data(as: FirestoreCondition.self)
                    let conditionData = firestoreCondition.toConditionData()
                    callback(conditionData)
                } catch {
                    print("Error decoding condition: \(error)")
                }
            }
    }

    func observeReportUpdates(callback: @escaping ([JubileeReport]) -> Void) {
        db.collection("reports")
            .order(by: "reportedAt", descending: true)
            .limit(to: 50)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching report updates: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                let reports: [JubileeReport] = documents.compactMap { document in
                    do {
                        let firestoreReport = try document.data(as: FirestoreReport.self)
                        return firestoreReport.toJubileeReport()
                    } catch {
                        print("Error decoding report: \(error)")
                        return nil
                    }
                }

                callback(reports)
            }
    }
}

// MARK: - Helper Extensions

extension JubileeReport {
    /// Convert SwiftData model to Firestore dictionary
    func toFirestoreData(userId: String) -> [String: Any] {
        return [
            "reportType": reportType.rawValue,
            "latitude": latitude,
            "longitude": longitude,
            "locationName": locationName,
            "intensity": intensity.rawValue,
            "species": species,
            "reportDescription": reportDescription ?? "",
            "reportedAt": Timestamp(date: reportedAt),
            "createdAt": Timestamp(date: createdAt),
            "reportedBy": userId,
            "verifications": verifications,
            "isVerified": isVerified,
            "photoURLs": photoURLs
        ]
    }
}

extension ConditionData {
    /// Convert SwiftData model to Firestore dictionary
    func toFirestoreData() -> [String: Any] {
        return [
            "score": score,
            "seasonalScore": seasonalScore,
            "timeWindowScore": timeWindowScore,
            "windScore": windScore,
            "tideScore": tideScore,
            "weatherPatternScore": weatherPatternScore,
            "waterQualityScore": waterQualityScore,
            "windSpeed": windSpeed,
            "windDirection": windDirection,
            "temperature": temperature,
            "tide": tide.rawValue,
            "nextHighTide": nextHighTide != nil ? Timestamp(date: nextHighTide!) : NSNull(),
            "nextLowTide": nextLowTide != nil ? Timestamp(date: nextLowTide!) : NSNull(),
            "salinity": salinity ?? NSNull(),
            "waterTemperature": waterTemperature ?? NSNull(),
            "dissolvedOxygen": dissolvedOxygen ?? NSNull(),
            "alertLevel": alertLevel.rawValue,
            "fetchedAt": Timestamp(date: fetchedAt)
        ]
    }
}
