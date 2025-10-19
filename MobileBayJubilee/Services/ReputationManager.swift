//
//  ReputationManager.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/19/25.
//  Phase 1 - Month 1: Manages user reputation scoring and badges
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

// MARK: - Reputation Manager

/// Manages reputation calculation and updates for users
/// Reputation is scored 0-100 based on report verification and community feedback
@MainActor
class ReputationManager: ObservableObject {

    // MARK: - Published Properties

    @Published var currentUserReputation: Int = 50
    @Published var currentUserBadge: String = "Contributor"
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Singleton

    static let shared = ReputationManager()

    private let db = Firestore.firestore()

    private init() {
        // Initialize with current user's reputation
        Task {
            await loadCurrentUserReputation()
        }
    }

    // MARK: - Reputation Calculation

    /// Calculate reputation change based on report verification status
    /// - Parameters:
    ///   - reportId: The unique identifier of the report
    ///   - verificationCount: Number of users who verified the report
    ///   - disputeCount: Number of users who disputed the report
    /// - Returns: The reputation change value (positive or negative)
    func calculateReputationChange(
        for reportId: UUID,
        verificationCount: Int,
        disputeCount: Int
    ) -> Int {
        // Positive reputation changes
        if verificationCount >= 3 {
            return 5 // Report verified by 3+ users
        } else if verificationCount >= 1 {
            return 2 // Report verified by 1-2 users
        }

        // Negative reputation changes
        if disputeCount >= 3 {
            return -3 // Report disputed by 3+ users
        }

        // No verification data yet
        return 0
    }

    /// Calculate reputation change for moderator-flagged reports
    /// - Parameters:
    ///   - reportId: The unique identifier of the report
    ///   - isFlagged: Whether the report was flagged as false by a moderator
    /// - Returns: The reputation change value
    func calculateModeratorReputationChange(
        for reportId: UUID,
        isFlagged: Bool
    ) -> Int {
        return isFlagged ? -10 : 0
    }

    // MARK: - Reputation Updates

    /// Update user reputation with the calculated change
    /// Ensures reputation stays within 0-100 range
    /// - Parameters:
    ///   - userId: The UUID of the user
    ///   - change: The reputation points to add or subtract
    func updateUserReputation(userId: UUID, change: Int) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw ReputationError.userNotAuthenticated
        }

        isLoading = true
        errorMessage = nil

        do {
            // Fetch current reputation from Firestore
            let userDoc = try await db.collection("users")
                .document(currentUser.uid)
                .getDocument()

            guard let currentReputation = userDoc.data()?["reputation"] as? Int else {
                throw ReputationError.reputationNotFound
            }

            // Calculate new reputation (capped at 0-100)
            let newReputation = max(0, min(100, currentReputation + change))

            // Update Firestore
            try await db.collection("users")
                .document(currentUser.uid)
                .updateData([
                    "reputation": newReputation,
                    "lastReputationUpdate": Timestamp(date: Date())
                ])

            // Update local state if this is the current user
            if currentUser.uid == userId.uuidString {
                self.currentUserReputation = newReputation
                self.currentUserBadge = getReputationBadge(for: newReputation)
            }

            isLoading = false

            print("✅ Reputation updated: \(currentReputation) -> \(newReputation) (change: \(change > 0 ? "+" : "")\(change))")

        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            throw error
        }
    }

    // MARK: - Reputation Badges

    /// Get reputation badge/level based on score
    /// - Parameter score: Reputation score (0-100)
    /// - Returns: Badge name as a string
    func getReputationBadge(for score: Int) -> String {
        switch score {
        case 0..<25:
            return "Novice Watcher"
        case 25..<50:
            return "Contributor"
        case 50..<70:
            return "Experienced Watcher"
        case 70..<90:
            return "Verified Watcher"
        case 90...100:
            return "Master Watcher"
        default:
            return "Contributor"
        }
    }

    /// Get reputation badge icon based on score
    /// - Parameter score: Reputation score (0-100)
    /// - Returns: SF Symbol name
    func getReputationBadgeIcon(for score: Int) -> String {
        switch score {
        case 0..<25:
            return "star"
        case 25..<50:
            return "star.fill"
        case 50..<70:
            return "2.circle.fill"
        case 70..<90:
            return "3.circle.fill"
        case 90...100:
            return "crown.fill"
        default:
            return "star.fill"
        }
    }

    // MARK: - Load Current User Reputation

    /// Load the current user's reputation from Firestore
    private func loadCurrentUserReputation() async {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        do {
            let userDoc = try await db.collection("users")
                .document(currentUser.uid)
                .getDocument()

            if let reputation = userDoc.data()?["reputation"] as? Int {
                self.currentUserReputation = reputation
                self.currentUserBadge = getReputationBadge(for: reputation)
            }
        } catch {
            print("❌ Failed to load user reputation: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch User Reputation

    /// Fetch reputation for any user by ID
    /// - Parameter userId: The UUID of the user
    /// - Returns: The user's current reputation score
    func fetchUserReputation(userId: UUID) async throws -> Int {
        do {
            let userDoc = try await db.collection("users")
                .document(userId.uuidString)
                .getDocument()

            guard let reputation = userDoc.data()?["reputation"] as? Int else {
                throw ReputationError.reputationNotFound
            }

            return reputation

        } catch {
            throw error
        }
    }

    // MARK: - Reputation Statistics

    /// Get reputation statistics for displaying in profile
    /// - Returns: Tuple with reputation, badge, and icon
    func getReputationStats() -> (reputation: Int, badge: String, icon: String) {
        return (
            reputation: currentUserReputation,
            badge: currentUserBadge,
            icon: getReputationBadgeIcon(for: currentUserReputation)
        )
    }
}

// MARK: - Reputation Error

enum ReputationError: LocalizedError {
    case userNotAuthenticated
    case reputationNotFound
    case invalidReputationValue
    case updateFailed

    var errorDescription: String? {
        switch self {
        case .userNotAuthenticated:
            return "User must be signed in to update reputation"
        case .reputationNotFound:
            return "User reputation data not found"
        case .invalidReputationValue:
            return "Invalid reputation value provided"
        case .updateFailed:
            return "Failed to update reputation"
        }
    }
}
