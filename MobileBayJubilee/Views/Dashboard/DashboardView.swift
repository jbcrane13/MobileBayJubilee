//
//  DashboardView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Main dashboard screen
//

import SwiftUI

struct DashboardView: View {
    // TODO: Replace with @Query from SwiftData when Firebase integration complete
    @State private var conditionData: ConditionData = .mockCurrent
    @State private var recentReports: [JubileeReport] = JubileeReport.mockReports.prefix(3).map { $0 }
    @State private var isRefreshing = false
    @State private var showReportSubmission = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Condition Score Section
                    VStack(spacing: 16) {
                        ConditionScoreGaugeView(conditionData: conditionData)

                        // Last updated timestamp
                        Text("Updated \(conditionData.fetchedAt, formatter: relativeTimeFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // MARK: - Quick Stats Section
                    QuickStatsView(conditionData: conditionData)
                        .padding(.horizontal)

                    // MARK: - Recent Reports Section
                    RecentReportsSection(reports: recentReports)
                        .padding(.horizontal)

                    Spacer(minLength: 80)
                }
            }

            // Floating Action Button
            Button {
                showReportSubmission = true
            } label: {
                HStack {
                    Image(systemName: "plus")
                        .font(.title3.bold())
                    Text("Report Jubilee")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color(red: 30/255, green: 64/255, blue: 175/255))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .padding()
            }
            .refreshable {
                await refreshData()
            }
            .navigationTitle("JubileeHub")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TODO: Navigate to settings
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $showReportSubmission) {
                ReportSubmissionView()
            }
        }
    }

    // MARK: - Methods

    @MainActor
    private func refreshData() async {
        isRefreshing = true

        // Simulate API call delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second

        // TODO: Replace with real Firebase fetch
        // For now, randomly vary the score to show animation
        let newScore = Int.random(in: 65...85)
        conditionData = ConditionData(
            score: newScore,
            seasonalScore: 20,
            timeWindowScore: Int.random(in: 10...20),
            windScore: Int.random(in: 8...15),
            tideScore: Int.random(in: 15...20),
            weatherPatternScore: Int.random(in: 5...10),
            waterQualityScore: 2,
            windSpeed: Double.random(in: 2.0...5.0),
            windDirection: ["N", "NE", "E", "NW"].randomElement()!,
            temperature: Double.random(in: 76...82),
            tide: TidePhase.allCases.randomElement()!,
            nextHighTide: Date().addingTimeInterval(6 * 3600),
            nextLowTide: Date().addingTimeInterval(-2 * 3600),
            salinity: Double.random(in: 10...15),
            waterTemperature: Double.random(in: 80...85),
            dissolvedOxygen: Double.random(in: 6.0...7.5),
            alertLevel: newScore >= 80 ? .confirmed : (newScore >= 70 ? .watch : .none),
            fetchedAt: Date()
        )

        isRefreshing = false
    }

    private var relativeTimeFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }
}

// MARK: - Quick Stats View

struct QuickStatsView: View {
    let conditionData: ConditionData

    var body: some View {
        HStack(spacing: 16) {
            // Next Tide
            StatCard(
                icon: "water.waves",
                title: "Next Tide",
                value: tideText,
                subtitle: tideTime,
                color: .blue
            )

            // Wind
            StatCard(
                icon: "wind",
                title: "Wind",
                value: String(format: "%.1f mph", conditionData.windSpeed),
                subtitle: conditionData.windDirection,
                color: .cyan
            )

            // Water Temp
            StatCard(
                icon: "thermometer.medium",
                title: "Water Temp",
                value: String(format: "%.0f°F", conditionData.waterTemperature ?? 0),
                subtitle: "Surface",
                color: .orange
            )
        }
    }

    private var tideText: String {
        let now = Date()
        if let nextLowTide = conditionData.nextLowTide, nextLowTide > now {
            return "Low"
        } else {
            return "High"
        }
    }

    private var tideTime: String {
        let now = Date()
        let nextTide: Date
        if let nextLowTide = conditionData.nextLowTide, nextLowTide > now {
            nextTide = nextLowTide
        } else if let nextHighTide = conditionData.nextHighTide {
            nextTide = nextHighTide
        } else {
            nextTide = now
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: nextTide)
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(color)

            Text(value)
                .font(.system(size: 18, weight: .semibold))

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Recent Reports Section

struct RecentReportsSection: View {
    let reports: [JubileeReport]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Reports")
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    // TODO: Navigate to all reports
                } label: {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundStyle(Color(red: 30/255, green: 64/255, blue: 175/255)) // Jubilee Blue
                }
            }

            if reports.isEmpty {
                EmptyReportsView()
            } else {
                VStack(spacing: 12) {
                    ForEach(reports) { report in
                        ReportCardView(report: report)
                    }
                }
            }
        }
    }
}

// MARK: - Report Card View

struct ReportCardView: View {
    let report: JubileeReport

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // Report type badge
                Text(report.reportType.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(reportTypeColor.opacity(0.2))
                    .foregroundColor(reportTypeColor)
                    .clipShape(Capsule())

                Spacer()

                // Time ago
                Text(report.timeAgo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Location and species
            Text(report.locationName)
                .font(.headline)

            if !report.species.isEmpty {
                Text(report.species.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            // Description (if any)
            if let description = report.reportDescription, !description.isEmpty {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            // Verification status
            HStack {
                Image(systemName: report.isVerified ? "checkmark.seal.fill" : "checkmark.seal")
                    .foregroundStyle(report.isVerified ? .green : .gray)
                    .font(.caption)

                Text("\(report.verifications) verifications")
                    .font(.caption)
                    .foregroundColor(.secondary)
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
            return Color(red: 220/255, green: 38/255, blue: 38/255) // Red
        case .earlyWarning:
            return Color(red: 245/255, green: 158/255, blue: 11/255) // Amber
        case .allClear:
            return Color(red: 107/255, green: 114/255, blue: 128/255) // Gray
        }
    }
}

// MARK: - Empty State

struct EmptyReportsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(.secondary)

            Text("No Recent Reports")
                .font(.headline)
                .foregroundColor(.secondary)

            Text("Be the first to report a jubilee event!")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

// MARK: - Preview

#Preview {
    DashboardView()
}

#Preview("Dark Mode") {
    DashboardView()
        .preferredColorScheme(.dark)
}
