//
//  CommunityView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Community feed screen
//

import SwiftUI

struct CommunityView: View {
    @State private var reports: [JubileeReport] = JubileeReport.mockReports
    @State private var selectedFilter: ReportFilter = .all
    @State private var isRefreshing = false
    @State private var selectedTab: CommunityTab = .feed
    @State private var activeChatRooms: [String] = [] // Active chat room IDs

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Tab Selector
                Picker("Community Section", selection: $selectedTab) {
                    ForEach(CommunityTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // MARK: - Content
                Group {
                    if selectedTab == .feed {
                        feedView
                    } else {
                        chatListView
                    }
                }
            }
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Feed View

    private var feedView: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Filter Tabs
                FilterTabsView(selectedFilter: $selectedFilter)
                    .padding(.horizontal)

                // MARK: - Reports Feed
                LazyVStack(spacing: 16) {
                    ForEach(filteredReports) { report in
                        CommunityReportCard(report: report)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)

                if filteredReports.isEmpty {
                    EmptyCommunityView(filter: selectedFilter)
                        .padding(.top, 60)
                }
            }
        }
        .refreshable {
            await refreshFeed()
        }
    }

    // MARK: - Chat List View

    private var chatListView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if activeChatRooms.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)

                        Text("No Active Chats")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text("Chat rooms are created automatically when jubilees are confirmed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else {
                    // Active chat rooms
                    ForEach(activeChatRooms, id: \.self) { roomId in
                        NavigationLink {
                            ChatView(roomId: roomId, roomTitle: formatRoomTitle(roomId))
                        } label: {
                            ChatRoomCard(roomId: roomId)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }

    // MARK: - Computed Properties

    private var filteredReports: [JubileeReport] {
        switch selectedFilter {
        case .all:
            return reports
        case .verified:
            return reports.filter { $0.isVerified }
        case .today:
            let today = Calendar.current.startOfDay(for: Date())
            return reports.filter { Calendar.current.startOfDay(for: $0.reportedAt) >= today }
        case .fullJubilee:
            return reports.filter { $0.reportType == .fullJubilee }
        case .earlyWarning:
            return reports.filter { $0.reportType == .earlyWarning }
        }
    }

    // MARK: - Methods

    @MainActor
    private func refreshFeed() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // TODO: Fetch from Firebase
        isRefreshing = false
    }

    private func formatRoomTitle(_ roomId: String) -> String {
        // Parse room ID like "point-clear-jubilee-2025-08-15-0234"
        let components = roomId.split(separator: "-")
        if components.count >= 2 {
            let location = components[0...1].joined(separator: " ").capitalized
            return "\(location) Chat"
        }
        return "Event Chat"
    }
}

// MARK: - Community Tab

enum CommunityTab: String, CaseIterable {
    case feed = "Feed"
    case chat = "Live Chat"
}

// MARK: - Report Filter

enum ReportFilter: String, CaseIterable {
    case all = "All"
    case verified = "Verified"
    case today = "Today"
    case fullJubilee = "Full Jubilee"
    case earlyWarning = "Early Warning"

    var icon: String {
        switch self {
        case .all: return "list.bullet"
        case .verified: return "checkmark.seal.fill"
        case .today: return "calendar"
        case .fullJubilee: return "exclamationmark.circle.fill"
        case .earlyWarning: return "eye.fill"
        }
    }
}

// MARK: - Filter Tabs View

struct FilterTabsView: View {
    @Binding var selectedFilter: ReportFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ReportFilter.allCases, id: \.self) { filter in
                    FilterTab(
                        filter: filter,
                        isSelected: selectedFilter == filter
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Filter Tab

struct FilterTab: View {
    let filter: ReportFilter
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: filter.icon)
                    .font(.caption)
                Text(filter.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? .appPrimary : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Community Report Card

struct CommunityReportCard: View {
    let report: JubileeReport
    @State private var showComments = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - Header
            HStack(spacing: 12) {
                // User avatar placeholder
                Circle()
                    .fill(Color.appPrimary.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.appPrimary)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Community Member") // TODO: Replace with actual user name
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    HStack(spacing: 4) {
                        Text(report.timeAgo)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("•")
                            .foregroundColor(.secondary)

                        Text(report.locationName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // Report type badge
                Text(report.reportType.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(reportTypeColor.opacity(0.2))
                    .foregroundColor(reportTypeColor)
                    .clipShape(Capsule())
            }

            // MARK: - Content
            if let description = report.reportDescription, !description.isEmpty {
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            // Species tags
            if !report.species.isEmpty {
                FlowLayout(spacing: 8) {
                    ForEach(report.species, id: \.self) { species in
                        Text(species)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                    }
                }
            }

            // Intensity indicator
            HStack(spacing: 8) {
                Image(systemName: "gauge.with.dots.needle.50percent")
                    .font(.caption)
                    .foregroundColor(intensityColor)

                Text("Intensity: \(intensityText)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            // MARK: - Action Bar
            HStack(spacing: 24) {
                // Verify button
                Button {
                    // TODO: Implement verify action
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: report.isVerified ? "checkmark.seal.fill" : "checkmark.seal")
                            .font(.subheadline)

                        Text("\(report.verifications)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(report.isVerified ? .green : .gray)
                }

                // Comment button
                Button {
                    showComments.toggle()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                            .font(.subheadline)

                        Text("Comment")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.gray)
                }

                // Share button
                Button {
                    // TODO: Implement share action
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.subheadline)

                        Text("Share")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.gray)
                }

                Spacer()

                // Map navigation
                Button {
                    // TODO: Navigate to map location
                } label: {
                    Image(systemName: "map")
                        .font(.subheadline)
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var reportTypeColor: Color {
        switch report.reportType {
        case .fullJubilee:
            return Color(red: 220/255, green: 38/255, blue: 38/255)
        case .earlyWarning:
            return Color(red: 245/255, green: 158/255, blue: 11/255)
        case .allClear:
            return Color(red: 107/255, green: 114/255, blue: 128/255)
        }
    }

    private var intensityText: String {
        switch report.intensity {
        case .extreme: return "Extreme"
        case .heavy: return "Heavy"
        case .moderate: return "Moderate"
        case .low: return "Low"
        }
    }

    private var intensityColor: Color {
        switch report.intensity {
        case .extreme:
            return Color(red: 220/255, green: 38/255, blue: 38/255)
        case .heavy:
            return Color(red: 245/255, green: 158/255, blue: 11/255)
        case .moderate:
            return Color(red: 251/255, green: 191/255, blue: 36/255)
        case .low:
            return Color(red: 107/255, green: 114/255, blue: 128/255)
        }
    }
}

// MARK: - Empty Community View

struct EmptyCommunityView: View {
    let filter: ReportFilter

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No \(filter.rawValue) Reports")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Be the first to share a jubilee event!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

// MARK: - Chat Room Card

struct ChatRoomCard: View {
    let roomId: String

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Circle()
                .fill(Color.appPrimary.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.title3)
                        .foregroundColor(.appPrimary)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(formatRoomName(roomId))
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("Active now")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func formatRoomName(_ roomId: String) -> String {
        let components = roomId.split(separator: "-")
        if components.count >= 2 {
            return components[0...1].joined(separator: " ").capitalized
        }
        return "Event Chat"
    }
}

// MARK: - Preview

#Preview {
    CommunityView()
}

#Preview("Dark Mode") {
    CommunityView()
        .preferredColorScheme(.dark)
}
