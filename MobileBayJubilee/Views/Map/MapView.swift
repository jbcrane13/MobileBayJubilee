//
//  MapView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Interactive map showing jubilee reports
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    // TODO: Replace with @Query from SwiftData when Firebase integration complete
    @State private var reports: [JubileeReport] = JubileeReport.mockReports
    @State private var selectedReport: JubileeReport?
    @State private var showReportDetail = false
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var showVerificationAlert = false
    @State private var verificationMessage = ""
    @State private var isVerifying = false
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.4955, longitude: -87.9064), // Mobile Bay center
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
    )

    private let firebaseService = RealFirebaseService.shared
    private let locationManager = CLLocationManager()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // MARK: - Map
                Map(position: $cameraPosition, selection: $selectedReport) {
                    // User location marker (will be enabled when location services added)
                    // UserAnnotation()

                    // Jubilee report markers
                    ForEach(reports) { report in
                        Annotation(report.locationName, coordinate: report.coordinate) {
                            ReportPinView(report: report)
                                .onTapGesture {
                                    selectedReport = report
                                    showReportDetail = true
                                }
                        }
                        .tag(report)
                    }
                }
                .mapStyle(.standard(elevation: .flat, pointsOfInterest: .including([.marina, .beach])))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }

                // MARK: - Report Detail Sheet
                if showReportDetail, let report = selectedReport {
                    ReportDetailCard(
                        report: report,
                        userLocation: userLocation,
                        onClose: {
                            showReportDetail = false
                            selectedReport = nil
                        },
                        onVerify: { isPositive in
                            verifyReport(report, isPositive: isPositive)
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: showReportDetail)
                }
            }
            .navigationTitle("Jubilee Map")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            // TODO: Filter by Full Jubilee
                        } label: {
                            Label("Full Jubilee", systemImage: "circle.fill")
                        }

                        Button {
                            // TODO: Filter by Early Warning
                        } label: {
                            Label("Early Warning", systemImage: "exclamationmark.triangle.fill")
                        }

                        Button {
                            // TODO: Filter by All Clear
                        } label: {
                            Label("All Clear", systemImage: "checkmark.circle.fill")
                        }

                        Divider()

                        Button {
                            // TODO: Show all reports
                        } label: {
                            Label("Show All", systemImage: "eye.fill")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .alert("Verification", isPresented: $showVerificationAlert) {
                Button("OK") {
                    showVerificationAlert = false
                }
            } message: {
                Text(verificationMessage)
            }
            .onAppear {
                requestLocationPermission()
            }
        }
    }

    // MARK: - Methods

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        if let location = locationManager.location {
            userLocation = location.coordinate
        }
    }

    private func verifyReport(_ report: JubileeReport, isPositive: Bool) {
        guard let userLoc = userLocation else {
            verificationMessage = "Unable to determine your location. Please enable location services."
            showVerificationAlert = true
            return
        }

        let reportCoordinate = CLLocationCoordinate2D(latitude: report.latitude, longitude: report.longitude)

        // Check if user is within 2 miles
        guard firebaseService.isUserNearReport(reportLocation: reportCoordinate, userLocation: userLoc, radiusMiles: 2.0) else {
            verificationMessage = "You must be within 2 miles of the report location to verify it."
            showVerificationAlert = true
            return
        }

        // Proceed with verification
        isVerifying = true

        Task {
            do {
                // Mock user ID - in production, get from Auth
                let userId = UUID()
                try await firebaseService.verifyReport(reportId: report.id, userId: userId, isPositive: isPositive)

                await MainActor.run {
                    isVerifying = false
                    verificationMessage = isPositive ? "Thank you for verifying this report!" : "Thank you for your feedback."
                    showVerificationAlert = true
                    showReportDetail = false
                    selectedReport = nil
                }
            } catch {
                await MainActor.run {
                    isVerifying = false
                    verificationMessage = "Failed to verify report: \(error.localizedDescription)"
                    showVerificationAlert = true
                }
            }
        }
    }
}

// MARK: - Report Pin View

struct ReportPinView: View {
    let report: JubileeReport

    var body: some View {
        VStack(spacing: 0) {
            // Pin circle
            Circle()
                .fill(pinColor)
                .frame(width: 32, height: 32)
                .overlay {
                    Image(systemName: pinIcon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)

            // Pin stem
            Triangle()
                .fill(pinColor)
                .frame(width: 12, height: 8)
                .offset(y: -1)
        }
        .frame(width: 32, height: 40)
    }

    private var pinColor: Color {
        switch report.reportType {
        case .fullJubilee:
            return Color(red: 220/255, green: 38/255, blue: 38/255) // Red
        case .earlyWarning:
            return Color(red: 245/255, green: 158/255, blue: 11/255) // Amber
        case .allClear:
            return Color(red: 107/255, green: 114/255, blue: 128/255) // Gray
        }
    }

    private var pinIcon: String {
        switch report.reportType {
        case .fullJubilee:
            return "exclamationmark"
        case .earlyWarning:
            return "eye"
        case .allClear:
            return "checkmark"
        }
    }
}

// MARK: - Triangle Shape (for pin stem)

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Report Detail Card

struct ReportDetailCard: View {
    let report: JubileeReport
    let userLocation: CLLocationCoordinate2D?
    let onClose: () -> Void
    let onVerify: (Bool) -> Void

    private var isWithinVerificationRange: Bool {
        guard let userLoc = userLocation else { return false }
        let reportLoc = CLLocationCoordinate2D(latitude: report.latitude, longitude: report.longitude)
        return RealFirebaseService.shared.isUserNearReport(reportLocation: reportLoc, userLocation: userLoc, radiusMiles: 2.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK: - Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // Report type badge
                    Text(report.reportType.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(reportTypeColor.opacity(0.2))
                        .foregroundColor(reportTypeColor)
                        .clipShape(Capsule())

                    Text(report.locationName)
                        .font(.title2)
                        .fontWeight(.bold)
                }

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }

            // MARK: - Time and Verification
            HStack {
                Label(report.timeAgo, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Spacer()

                HStack(spacing: 4) {
                    Image(systemName: report.isVerified ? "checkmark.seal.fill" : "checkmark.seal")
                        .foregroundStyle(report.isVerified ? .green : .gray)
                    Text("\(report.verifications)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            // MARK: - Species
            if !report.species.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Species Reported")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    FlowLayout(spacing: 8) {
                        ForEach(report.species, id: \.self) { species in
                            Text(species)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .clipShape(Capsule())
                        }
                    }
                }
            }

            // MARK: - Intensity
            HStack {
                Text("Intensity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Spacer()

                Text(intensityText)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(intensityColor)
            }

            // MARK: - Description
            if let description = report.reportDescription, !description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }

            // MARK: - Actions
            VStack(spacing: 12) {
                // Verify buttons (only show if within range)
                if isWithinVerificationRange {
                    HStack(spacing: 12) {
                        Button {
                            onVerify(true)
                        } label: {
                            Label("Verify (Thumbs Up)", systemImage: "hand.thumbsup.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        Button {
                            onVerify(false)
                        } label: {
                            Label("Dispute", systemImage: "hand.thumbsdown.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Text("You're within 2 miles - verify this report")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "location.slash")
                            .foregroundColor(.secondary)

                        Text("Verification available within 2 miles")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Verification count display
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(report.isVerified ? .green : .gray)

                    Text("\(report.verifications) verification\(report.verifications == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        .padding()
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

    private var intensityText: String {
        switch report.intensity {
        case .extreme:
            return "Extreme"
        case .heavy:
            return "Heavy"
        case .moderate:
            return "Moderate"
        case .low:
            return "Low"
        }
    }

    private var intensityColor: Color {
        switch report.intensity {
        case .extreme:
            return Color(red: 220/255, green: 38/255, blue: 38/255) // Red
        case .heavy:
            return Color(red: 245/255, green: 158/255, blue: 11/255) // Amber
        case .moderate:
            return Color(red: 251/255, green: 191/255, blue: 36/255) // Yellow
        case .low:
            return Color(red: 107/255, green: 114/255, blue: 128/255) // Gray
        }
    }
}

// MARK: - Flow Layout (for species tags)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var currentX: CGFloat = 0
            var currentY: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if currentX + size.width > maxWidth && currentX > 0 {
                    currentX = 0
                    currentY += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: currentX, y: currentY))
                currentX += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }

            self.size = CGSize(width: maxWidth, height: currentY + lineHeight)
        }
    }
}

// MARK: - Preview

#Preview {
    MapView()
}

#Preview("Dark Mode") {
    MapView()
        .preferredColorScheme(.dark)
}
