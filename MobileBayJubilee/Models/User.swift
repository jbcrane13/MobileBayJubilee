//
//  User.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 2025-10-18.
//  SwiftData model for User profiles and authentication
//

import Foundation
import SwiftData

@Model
final class User {
    // MARK: - Properties

    /// Unique identifier
    var id: UUID

    /// User's display name
    var displayName: String

    /// User's email address
    var email: String

    /// Profile photo URL (Cloud Storage)
    var profilePhotoURL: String?

    /// Reputation score (0-100)
    var reputation: Int

    /// Verified watcher status
    var isVerifiedWatcher: Bool

    /// Favorite beach locations
    var favoriteLocations: [String] // Array of location IDs

    /// Notification preferences
    var notificationThreshold: Int // Condition Score threshold (0-100)
    var notificationsEnabled: Bool

    /// Account creation date
    var createdAt: Date

    /// Last login date
    var lastLoginAt: Date

    // MARK: - Relationships

    /// Reports submitted by this user
    @Relationship(deleteRule: .cascade, inverse: \JubileeReport.author)
    var reports: [JubileeReport]?

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        displayName: String,
        email: String,
        profilePhotoURL: String? = nil,
        reputation: Int = 50,
        isVerifiedWatcher: Bool = false,
        favoriteLocations: [String] = [],
        notificationThreshold: Int = 70,
        notificationsEnabled: Bool = true,
        createdAt: Date = Date(),
        lastLoginAt: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.profilePhotoURL = profilePhotoURL
        self.reputation = reputation
        self.isVerifiedWatcher = isVerifiedWatcher
        self.favoriteLocations = favoriteLocations
        self.notificationThreshold = notificationThreshold
        self.notificationsEnabled = notificationsEnabled
        self.createdAt = createdAt
        self.lastLoginAt = lastLoginAt
    }
}

// MARK: - Computed Properties

extension User {
    /// Reputation level based on score
    var reputationLevel: ReputationLevel {
        switch reputation {
        case 0..<25:
            return .novice
        case 25..<50:
            return .contributor
        case 50..<75:
            return .experienced
        case 75..<90:
            return .expert
        default:
            return .master
        }
    }
}

// MARK: - Reputation Level

enum ReputationLevel: String, Codable {
    case novice = "Novice"
    case contributor = "Contributor"
    case experienced = "Experienced"
    case expert = "Expert Watcher"
    case master = "Master Watcher"

    var badgeIcon: String {
        switch self {
        case .novice: return "star"
        case .contributor: return "star.fill"
        case .experienced: return "2.circle.fill"
        case .expert: return "3.circle.fill"
        case .master: return "crown.fill"
        }
    }
}
