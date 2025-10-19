//
//  ChatMessage.swift
//  MobileBayJubilee
//
//  Created by Feature Dev Agent 1 on 10/19/25.
//  Model for real-time chat messages in Firebase Realtime Database
//

import Foundation

// MARK: - Chat Message

/// Chat message model for Firebase Realtime Database
struct ChatMessage: Identifiable, Codable, Equatable {
    // MARK: - Properties

    /// Unique identifier
    var id: String

    /// Chat room identifier (event-based: "point-clear-2025-08-15-0234")
    var roomId: String

    /// User who sent the message
    var userId: String // Firebase Auth UID
    var userName: String
    var userReputation: Int

    /// Message content
    var message: String

    /// Timestamp
    var timestamp: Date

    /// Message metadata
    var isSystemMessage: Bool

    // MARK: - Initialization

    init(
        id: String = UUID().uuidString,
        roomId: String,
        userId: String,
        userName: String,
        userReputation: Int = 50,
        message: String,
        timestamp: Date = Date(),
        isSystemMessage: Bool = false
    ) {
        self.id = id
        self.roomId = roomId
        self.userId = userId
        self.userName = userName
        self.userReputation = userReputation
        self.message = message
        self.timestamp = timestamp
        self.isSystemMessage = isSystemMessage
    }

    // MARK: - Firestore Conversion

    /// Convert to dictionary for Firebase Realtime Database
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "roomId": roomId,
            "userId": userId,
            "userName": userName,
            "userReputation": userReputation,
            "message": message,
            "timestamp": timestamp.timeIntervalSince1970,
            "isSystemMessage": isSystemMessage
        ]
    }

    /// Create from Firebase Realtime Database dictionary
    static func from(dictionary: [String: Any], id: String) -> ChatMessage? {
        guard let roomId = dictionary["roomId"] as? String,
              let userId = dictionary["userId"] as? String,
              let userName = dictionary["userName"] as? String,
              let userReputation = dictionary["userReputation"] as? Int,
              let message = dictionary["message"] as? String,
              let timestampDouble = dictionary["timestamp"] as? Double else {
            return nil
        }

        let timestamp = Date(timeIntervalSince1970: timestampDouble)
        let isSystemMessage = dictionary["isSystemMessage"] as? Bool ?? false

        return ChatMessage(
            id: id,
            roomId: roomId,
            userId: userId,
            userName: userName,
            userReputation: userReputation,
            message: message,
            timestamp: timestamp,
            isSystemMessage: isSystemMessage
        )
    }
}

// MARK: - Computed Properties

extension ChatMessage {
    /// Time ago string for display
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }

    /// Is message from current user
    func isFromCurrentUser(userId: String) -> Bool {
        return self.userId == userId
    }

    /// User reputation badge
    var reputationBadge: String {
        switch userReputation {
        case 0..<25:
            return "⭐️"
        case 25..<50:
            return "⭐️⭐️"
        case 50..<75:
            return "⭐️⭐️⭐️"
        case 75..<90:
            return "👑"
        default:
            return "🏆"
        }
    }
}

// MARK: - Chat Room

/// Chat room model for organizing event-based conversations
struct ChatRoom: Identifiable, Codable {
    var id: String // e.g., "point-clear-2025-08-15-0234"
    var eventLocation: String // e.g., "Point Clear"
    var eventDate: Date
    var isActive: Bool
    var participantCount: Int
    var lastMessageAt: Date

    /// Create room ID from event details
    static func createRoomId(for event: String, location: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HHmm"
        let dateString = dateFormatter.string(from: Date())

        let normalizedEvent = event.lowercased().replacingOccurrences(of: " ", with: "-")
        let normalizedLocation = location.lowercased().replacingOccurrences(of: " ", with: "-")

        return "\(normalizedLocation)-\(normalizedEvent)-\(dateString)"
    }

    /// Convert to dictionary
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "eventLocation": eventLocation,
            "eventDate": eventDate.timeIntervalSince1970,
            "isActive": isActive,
            "participantCount": participantCount,
            "lastMessageAt": lastMessageAt.timeIntervalSince1970
        ]
    }
}
