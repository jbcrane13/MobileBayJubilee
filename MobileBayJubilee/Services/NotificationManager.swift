//
//  NotificationManager.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/19/25.
//  Phase 1 - Month 1: Manages push notifications and APNs framework
//

import Foundation
import SwiftUI
import Combine
import UserNotifications
import FirebaseMessaging
import FirebaseAuth
import FirebaseFirestore

// MARK: - Notification Manager

/// Manages Apple Push Notification service (APNs) and local notifications
/// Handles device token registration, permissions, and notification scheduling
@MainActor
class NotificationManager: NSObject, ObservableObject {

    // MARK: - Published Properties

    @Published var authorizationStatus: UNAuthorizationStatus = .notDetermined
    @Published var isEnabled = false
    @Published var errorMessage: String?

    // MARK: - Singleton

    static let shared = NotificationManager()

    private let db = Firestore.firestore()
    private let notificationCenter = UNUserNotificationCenter.current()

    private override init() {
        super.init()
        notificationCenter.delegate = self
        Task {
            await checkAuthorizationStatus()
        }
    }

    // MARK: - Permission Management

    /// Request notification permissions from the user
    /// Requests authorization for alerts, badges, and sounds
    func requestPermissions() async throws {
        do {
            let granted = try await notificationCenter.requestAuthorization(
                options: [.alert, .badge, .sound]
            )

            self.isEnabled = granted
            self.authorizationStatus = granted ? .authorized : .denied

            if granted {
                // Register for remote notifications on the main thread
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                print("✅ Notification permissions granted")
            } else {
                print("❌ Notification permissions denied")
            }

        } catch {
            self.errorMessage = error.localizedDescription
            throw NotificationError.permissionDenied
        }
    }

    /// Check current notification authorization status
    func checkAuthorizationStatus() async {
        let settings = await notificationCenter.notificationSettings()
        self.authorizationStatus = settings.authorizationStatus
        self.isEnabled = settings.authorizationStatus == .authorized
    }

    // MARK: - Device Token Registration

    /// Register device token with Firebase Cloud Messaging
    /// Called from AppDelegate when APNs token is received
    /// - Parameter deviceToken: The APNs device token
    func registerDeviceToken(_ deviceToken: Data) {
        // Set APNs token for Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken

        // Get FCM token
        Messaging.messaging().token { token, error in
            if let error = error {
                print("❌ Error fetching FCM token: \(error.localizedDescription)")
                return
            }

            if let token = token {
                print("✅ FCM Token: \(token)")
                Task {
                    await self.saveFCMTokenToFirestore(token)
                }
            }
        }
    }

    /// Save FCM token to Firestore user document
    /// - Parameter token: The Firebase Cloud Messaging token
    private func saveFCMTokenToFirestore(_ token: String) async {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        do {
            try await db.collection("users")
                .document(currentUser.uid)
                .updateData([
                    "fcmToken": token,
                    "fcmTokenUpdatedAt": Timestamp(date: Date())
                ])

            print("✅ FCM token saved to Firestore")

        } catch {
            print("❌ Failed to save FCM token: \(error.localizedDescription)")
        }
    }

    // MARK: - Local Notification Scheduling

    /// Schedule a local notification for condition score threshold alerts
    /// - Parameters:
    ///   - title: Notification title
    ///   - body: Notification body message
    ///   - threshold: The condition score that triggered the alert
    ///   - timeInterval: Time interval before notification fires (default: 5 seconds for testing)
    func scheduleConditionScoreAlert(
        title: String,
        body: String,
        threshold: Int,
        timeInterval: TimeInterval = 5
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.conditionAlert.rawValue
        content.userInfo = [
            "type": NotificationType.conditionScore.rawValue,
            "threshold": threshold,
            "timestamp": Date().timeIntervalSince1970
        ]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
            print("✅ Condition score alert scheduled: \(title)")
        } catch {
            throw NotificationError.schedulingFailed
        }
    }

    /// Schedule a local notification for community alerts (WATCH/CONFIRMED)
    /// - Parameters:
    ///   - title: Notification title
    ///   - body: Notification body message
    ///   - alertType: The type of community alert (watch or confirmed)
    ///   - reportId: The ID of the associated report
    ///   - timeInterval: Time interval before notification fires
    func scheduleCommunityAlert(
        title: String,
        body: String,
        alertType: CommunityAlertType,
        reportId: UUID,
        timeInterval: TimeInterval = 5
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .defaultCritical // Use critical sound for jubilee alerts
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.communityAlert.rawValue
        content.userInfo = [
            "type": NotificationType.communityAlert.rawValue,
            "alertType": alertType.rawValue,
            "reportId": reportId.uuidString,
            "timestamp": Date().timeIntervalSince1970
        ]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
            print("✅ Community alert scheduled: \(title)")
        } catch {
            throw NotificationError.schedulingFailed
        }
    }

    /// Schedule a local notification for chat messages (opt-in)
    /// - Parameters:
    ///   - title: Notification title
    ///   - body: Notification body message
    ///   - senderId: The ID of the user who sent the message
    ///   - chatId: The ID of the chat/conversation
    ///   - timeInterval: Time interval before notification fires
    func scheduleChatMessageAlert(
        title: String,
        body: String,
        senderId: UUID,
        chatId: UUID,
        timeInterval: TimeInterval = 5
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.chatMessage.rawValue
        content.userInfo = [
            "type": NotificationType.chatMessage.rawValue,
            "senderId": senderId.uuidString,
            "chatId": chatId.uuidString,
            "timestamp": Date().timeIntervalSince1970
        ]

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: timeInterval,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
            print("✅ Chat message alert scheduled: \(title)")
        } catch {
            throw NotificationError.schedulingFailed
        }
    }

    // MARK: - Notification Management

    /// Remove all pending notifications
    func removeAllPendingNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        print("🗑️ All pending notifications removed")
    }

    /// Remove all delivered notifications
    func removeAllDeliveredNotifications() {
        notificationCenter.removeAllDeliveredNotifications()
        UIApplication.shared.applicationIconBadgeNumber = 0
        print("🗑️ All delivered notifications removed")
    }

    /// Get count of pending notifications
    func getPendingNotificationCount() async -> Int {
        let pending = await notificationCenter.pendingNotificationRequests()
        return pending.count
    }

    /// Get count of delivered notifications
    func getDeliveredNotificationCount() async -> Int {
        let delivered = await notificationCenter.deliveredNotifications()
        return delivered.count
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationManager: UNUserNotificationCenterDelegate {

    /// Handle notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }

    /// Handle notification tap
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        // Handle different notification types
        if let typeString = userInfo["type"] as? String,
           let type = NotificationType(rawValue: typeString) {

            switch type {
            case .conditionScore:
                print("📊 User tapped condition score notification")
                // TODO: Navigate to dashboard view

            case .communityAlert:
                if let reportId = userInfo["reportId"] as? String {
                    print("🚨 User tapped community alert for report: \(reportId)")
                    // TODO: Navigate to specific report detail
                }

            case .chatMessage:
                if let chatId = userInfo["chatId"] as? String {
                    print("💬 User tapped chat message notification: \(chatId)")
                    // TODO: Navigate to chat view
                }
            }
        }

        completionHandler()
    }
}

// MARK: - Notification Types

/// Types of notifications the app can send
enum NotificationType: String {
    case conditionScore = "condition_score"
    case communityAlert = "community_alert"
    case chatMessage = "chat_message"
}

/// Categories for notification organization
enum NotificationCategory: String {
    case conditionAlert = "CONDITION_ALERT"
    case communityAlert = "COMMUNITY_ALERT"
    case chatMessage = "CHAT_MESSAGE"
}

/// Types of community alerts
enum CommunityAlertType: String, Codable {
    case watch = "WATCH"
    case confirmed = "CONFIRMED"
    case allClear = "ALL_CLEAR"
}

// MARK: - Notification Payload Structures

/// Payload structure for condition score alerts
/// Used by Cloud Functions to send push notifications
struct ConditionScoreNotificationPayload: Codable {
    let title: String
    let body: String
    let conditionScore: Int
    let threshold: Int
    let timestamp: Date

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "body": body,
            "conditionScore": conditionScore,
            "threshold": threshold,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
}

/// Payload structure for community alerts
/// Used by Cloud Functions to send push notifications
struct CommunityAlertNotificationPayload: Codable {
    let title: String
    let body: String
    let alertType: CommunityAlertType
    let reportId: String
    let locationName: String
    let timestamp: Date

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "body": body,
            "alertType": alertType.rawValue,
            "reportId": reportId,
            "locationName": locationName,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
}

/// Payload structure for chat message notifications
/// Used by Cloud Functions to send push notifications
struct ChatMessageNotificationPayload: Codable {
    let title: String
    let body: String
    let senderId: String
    let senderName: String
    let chatId: String
    let timestamp: Date

    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "body": body,
            "senderId": senderId,
            "senderName": senderName,
            "chatId": chatId,
            "timestamp": timestamp.timeIntervalSince1970
        ]
    }
}

// MARK: - Notification Error

enum NotificationError: LocalizedError {
    case permissionDenied
    case schedulingFailed
    case invalidPayload
    case tokenRegistrationFailed

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permissions denied by user"
        case .schedulingFailed:
            return "Failed to schedule notification"
        case .invalidPayload:
            return "Invalid notification payload"
        case .tokenRegistrationFailed:
            return "Failed to register device token"
        }
    }
}
