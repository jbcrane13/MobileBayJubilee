//
//  DashboardView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Main dashboard screen
//

import SwiftUI

struct DashboardView: View {
    @State private var conditionData: ConditionData = .mockCurrent
    @State private var recentReports: [JubileeReport] = JubileeReport.mockReports.prefix(3).map { $0 }
    @State private var isRefreshing = false
    @State private var showReportSubmission = false

    private let conditionScoreService = ConditionScoreService.shared
    private let firebaseService = RealFirebaseService.shared

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

        // Try to fetch from Firebase first
        if let latestCondition = try? await firebaseService.fetchCurrentCondition() {
            conditionData = latestCondition

            // Also fetch latest reports
            if let latestReports = try? await firebaseService.fetchRecentReports(limit: 3) {
                recentReports = latestReports
            }
        } else {
            // Fallback: Generate mock environmental data and calculate real score
            let mockEnvData = generateMockEnvironmentalData()

            // Calculate real condition score using ConditionScoreService
            conditionData = conditionScoreService.calculateConditionScore(
                date: Date(),
                windSpeed: mockEnvData.windSpeed,
                windDirection: mockEnvData.windDirection,
                tide: mockEnvData.tide,
                nextHighTide: mockEnvData.nextHighTide,
                nextLowTide: mockEnvData.nextLowTide,
                waterTemperature: mockEnvData.waterTemperature,
                weatherPattern: mockEnvData.weatherPattern,
                salinity: mockEnvData.salinity,
                airTemperature: mockEnvData.airTemperature
            )
        }

        isRefreshing = false
    }

    /// Generate realistic mock environmental data for development
    private func generateMockEnvironmentalData() -> (
        windSpeed: Double,
        windDirection: String,
        tide: TidePhase,
        nextHighTide: Date,
        nextLowTide: Date,
        waterTemperature: Double,
        weatherPattern: WeatherPattern,
        salinity: Double,
        airTemperature: Double
    ) {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)

        // Simulate favorable conditions more often during optimal hours
        let isOptimalTime = (hour >= 21 || hour < 8)

        // Wind: More favorable (E, SE, NE) during optimal times
        let favorableDirections = ["E", "SE", "NE", "ESE"]
        let unfavorableDirections = ["N", "NW", "S"]
        let windDirection = isOptimalTime ?
            favorableDirections.randomElement()! :
            (Bool.random() ? favorableDirections : unfavorableDirections).randomElement()!

        // Wind speed: 2-8 mph is optimal
        let windSpeed = Double.random(in: 1.0...4.0) // m/s (~2-9 mph)

        // Tide: Rising tide is optimal
        let tide: TidePhase = Bool.random() ? .rising : .falling

        // Next tides (6 hours apart typically)
        let nextHighTide = now.addingTimeInterval(Double.random(in: 2...10) * 3600)
        let nextLowTide = now.addingTimeInterval(Double.random(in: 1...5) * 3600)

        // Water temperature: 26-30°C (79-86°F) is optimal
        let waterTemperature = Double.random(in: 26.0...30.0)

        // Weather pattern
        let weatherPattern: WeatherPattern = [.clear, .partlyCloudy, .overcast].randomElement()!

        // Salinity: 10-15 PSU is optimal (low salinity zone)
        let salinity = Double.random(in: 10.0...15.0)

        // Air temperature: ~28°C (82°F)
        let airTemperature = Double.random(in: 26.0...32.0)

        return (
            windSpeed: windSpeed,
            windDirection: windDirection,
            tide: tide,
            nextHighTide: nextHighTide,
            nextLowTide: nextLowTide,
            waterTemperature: waterTemperature,
            weatherPattern: weatherPattern,
            salinity: salinity,
            airTemperature: airTemperature
        )
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
