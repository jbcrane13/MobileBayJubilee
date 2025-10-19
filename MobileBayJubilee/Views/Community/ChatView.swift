//
//  ChatView.swift
//  MobileBayJubilee
//
//  Created by Feature Dev Agent 1 on 10/19/25.
//  Real-time chat view for jubilee events
//

import SwiftUI

struct ChatView: View {
    let roomId: String
    let roomTitle: String

    @State private var messages: [ChatMessage] = []
    @State private var messageText: String = ""
    @State private var isLoading = true
    @State private var errorMessage: String?

    private let firebaseService = RealFirebaseService.shared

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Messages List
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            ChatMessageRow(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { oldValue, newValue in
                    // Auto-scroll to latest message
                    if let lastMessage = messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }

            Divider()

            // MARK: - Message Input
            HStack(spacing: 12) {
                TextField("Type a message...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .lineLimit(1...3)

                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(messageText.isEmpty ? .gray : .appPrimary)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle(roomTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            observeMessages()
        }
        .onDisappear {
            firebaseService.stopObservingChatMessages(roomId: roomId)
        }
        .overlay {
            if isLoading && messages.isEmpty {
                ProgressView("Loading chat...")
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let error = errorMessage {
                Text(error)
            }
        }
    }

    // MARK: - Methods

    private func observeMessages() {
        firebaseService.observeChatMessages(roomId: roomId) { newMessages in
            withAnimation {
                messages = newMessages
                isLoading = false
            }
        }
    }

    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        Task {
            do {
                try await firebaseService.sendChatMessage(to: roomId, message: trimmedMessage)
                await MainActor.run {
                    messageText = ""
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to send message: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Chat Message Row

struct ChatMessageRow: View {
    let message: ChatMessage

    // Mock current user ID - in production, get from Auth
    private let currentUserId = "current-user-id"

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if message.isFromCurrentUser(userId: currentUserId) {
                Spacer(minLength: 60)
            }

            VStack(alignment: message.isFromCurrentUser(userId: currentUserId) ? .trailing : .leading, spacing: 4) {
                // User info
                if !message.isFromCurrentUser(userId: currentUserId) {
                    HStack(spacing: 4) {
                        Text(message.userName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)

                        Text(message.reputationBadge)
                            .font(.caption2)
                    }
                }

                // Message bubble
                Text(message.message)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        message.isFromCurrentUser(userId: currentUserId)
                            ? Color.appPrimary
                            : Color(.systemGray5)
                    )
                    .foregroundColor(
                        message.isFromCurrentUser(userId: currentUserId)
                            ? .white
                            : .primary
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                // Timestamp
                Text(message.timeAgo)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            if !message.isFromCurrentUser(userId: currentUserId) {
                Spacer(minLength: 60)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ChatView(
            roomId: "point-clear-jubilee-2025-08-15-0234",
            roomTitle: "Point Clear Jubilee"
        )
    }
}
