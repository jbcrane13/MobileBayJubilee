//
//  ReportSubmissionView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: Report submission flow (4-step wizard)
//

import SwiftUI
import MapKit

struct ReportSubmissionView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep: SubmissionStep = .type
    @State private var reportType: ReportType = .fullJubilee
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var locationName: String = ""
    @State private var selectedSpecies: Set<String> = []
    @State private var intensity: ReportIntensity = .moderate
    @State private var reportDescription: String = ""
    @State private var selectedPhotos: [UIImage] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress indicator
                ProgressStepView(currentStep: currentStep)
                    .padding()

                // Step content
                ScrollView {
                    switch currentStep {
                    case .type:
                        ReportTypeSelectionView(selectedType: $reportType)
                    case .location:
                        LocationSelectionView(
                            selectedLocation: $selectedLocation,
                            locationName: $locationName
                        )
                    case .details:
                        ReportDetailsView(
                            selectedSpecies: $selectedSpecies,
                            intensity: $intensity,
                            reportDescription: $reportDescription,
                            selectedPhotos: $selectedPhotos
                        )
                    case .review:
                        ReportReviewView(
                            reportType: reportType,
                            locationName: locationName,
                            selectedSpecies: selectedSpecies,
                            intensity: intensity,
                            reportDescription: reportDescription,
                            photoCount: selectedPhotos.count
                        )
                    }
                }

                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep != .type {
                        Button {
                            withAnimation {
                                currentStep = currentStep.previous()
                            }
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray5))
                                .foregroundColor(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    Button {
                        if currentStep == .review {
                            submitReport()
                        } else {
                            withAnimation {
                                currentStep = currentStep.next()
                            }
                        }
                    } label: {
                        Text(currentStep == .review ? "Submit Report" : "Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canContinue ? Color(red: 30/255, green: 64/255, blue: 175/255) : Color.gray)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!canContinue)
                }
                .padding()
            }
            .navigationTitle("Report Jubilee")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    // MARK: - Computed Properties

    private var canContinue: Bool {
        switch currentStep {
        case .type:
            return true
        case .location:
            return selectedLocation != nil && !locationName.isEmpty
        case .details:
            return !selectedSpecies.isEmpty
        case .review:
            return true
        }
    }

    // MARK: - Methods

    private func submitReport() {
        guard let location = selectedLocation else {
            print("❌ Cannot submit report without location")
            return
        }

        // Create report object
        let report = JubileeReport(
            reportType: reportType,
            latitude: location.latitude,
            longitude: location.longitude,
            locationName: locationName,
            species: Array(selectedSpecies),
            intensity: intensity,
            reportDescription: reportDescription.isEmpty ? nil : reportDescription,
            photoURLs: [], // No photo support yet
            verifications: 0,
            isVerified: false,
            reportedAt: Date(),
            createdAt: Date(),
            author: nil // Will be set by Firebase when we have auth
        )

        // Submit to Firebase and trigger notifications
        Task {
            do {
                // Submit report to Firebase
                let firebaseService = RealFirebaseService.shared
                try await firebaseService.submitReport(report)
                print("✅ Report submitted successfully")

                // Check if immediate notification should be triggered
                let alertManager = AlertLevelManager.shared
                let notificationManager = NotificationManager.shared

                // For full jubilee or early warning from any user, send notification
                // (In production, this would check user reputation)
                if report.reportType == .fullJubilee || report.reportType == .earlyWarning {
                    let alertType: CommunityAlertType = report.reportType == .fullJubilee ? .confirmed : .watch
                    let title = report.reportType == .fullJubilee ? "Jubilee Alert: CONFIRMED" : "Jubilee Watch"
                    let body = "Jubilee event reported at \(report.locationName). Check the map for details."

                    try await notificationManager.scheduleCommunityAlert(
                        title: title,
                        body: body,
                        alertType: alertType,
                        reportId: report.id,
                        timeInterval: 1 // Send immediately (1 second delay)
                    )
                    print("✅ Notification scheduled for report")
                }

                await MainActor.run {
                    dismiss()
                }

            } catch {
                print("❌ Failed to submit report: \(error.localizedDescription)")
                // TODO: Show error alert to user
                await MainActor.run {
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Submission Step

enum SubmissionStep: Int, CaseIterable {
    case type = 0
    case location = 1
    case details = 2
    case review = 3

    func next() -> SubmissionStep {
        SubmissionStep(rawValue: self.rawValue + 1) ?? .review
    }

    func previous() -> SubmissionStep {
        SubmissionStep(rawValue: self.rawValue - 1) ?? .type
    }

    var title: String {
        switch self {
        case .type: return "Type"
        case .location: return "Location"
        case .details: return "Details"
        case .review: return "Review"
        }
    }
}

// MARK: - Progress Step View

struct ProgressStepView: View {
    let currentStep: SubmissionStep

    var body: some View {
        HStack(spacing: 12) {
            ForEach(SubmissionStep.allCases, id: \.self) { step in
                VStack(spacing: 4) {
                    Circle()
                        .fill(step.rawValue <= currentStep.rawValue ? Color(red: 30/255, green: 64/255, blue: 175/255) : Color(.systemGray4))
                        .frame(width: 32, height: 32)
                        .overlay {
                            if step.rawValue < currentStep.rawValue {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(step.rawValue + 1)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(step == currentStep ? .white : .gray)
                            }
                        }

                    Text(step.title)
                        .font(.caption2)
                        .foregroundColor(step == currentStep ? .primary : .secondary)
                }

                if step != .review {
                    Rectangle()
                        .fill(step.rawValue < currentStep.rawValue ? Color(red: 30/255, green: 64/255, blue: 175/255) : Color(.systemGray4))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Report Type Selection View

struct ReportTypeSelectionView: View {
    @Binding var selectedType: ReportType

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("What type of report are you submitting?")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)

            VStack(spacing: 16) {
                ReportTypeCard(
                    type: .fullJubilee,
                    icon: "exclamationmark.circle.fill",
                    title: "Full Jubilee",
                    description: "Active jubilee event with marine life at shore",
                    color: Color(red: 220/255, green: 38/255, blue: 38/255),
                    isSelected: selectedType == .fullJubilee
                ) {
                    selectedType = .fullJubilee
                }

                ReportTypeCard(
                    type: .earlyWarning,
                    icon: "eye.fill",
                    title: "Early Warning",
                    description: "Signs of an approaching jubilee event",
                    color: Color(red: 245/255, green: 158/255, blue: 11/255),
                    isSelected: selectedType == .earlyWarning
                ) {
                    selectedType = .earlyWarning
                }

                ReportTypeCard(
                    type: .allClear,
                    icon: "checkmark.circle.fill",
                    title: "All Clear",
                    description: "Jubilee event has ended",
                    color: Color(red: 107/255, green: 114/255, blue: 128/255),
                    isSelected: selectedType == .allClear
                ) {
                    selectedType = .allClear
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

// MARK: - Report Type Card

struct ReportTypeCard: View {
    let type: ReportType
    let icon: String
    let title: String
    let description: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                    .frame(width: 50)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(color)
                }
            }
            .padding()
            .background(isSelected ? color.opacity(0.1) : Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Location Selection View

struct LocationSelectionView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var locationName: String

    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.4955, longitude: -87.9064),
            span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3)
        )
    )

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Where is this jubilee occurring?")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)

            VStack(spacing: 16) {
                // Map picker
                ZStack {
                    Map(position: $cameraPosition) {
                        if let location = selectedLocation {
                            Annotation("Selected Location", coordinate: location) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture { location in
                        // TODO: Convert tap location to coordinate
                        // For now, set a default location
                        selectedLocation = CLLocationCoordinate2D(latitude: 30.4866, longitude: -87.9249)
                    }

                    // Crosshair in center
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.red)
                        .allowsHitTesting(false)
                }
                .padding(.horizontal)

                // Location name input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Location Name")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    TextField("e.g., Point Clear, Fairhope Pier", text: $locationName)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal)

                // Quick location buttons
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quick Locations")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            QuickLocationButton(name: "Point Clear") {
                                selectedLocation = CLLocationCoordinate2D(latitude: 30.4866, longitude: -87.9249)
                                locationName = "Point Clear"
                            }

                            QuickLocationButton(name: "Fairhope Pier") {
                                selectedLocation = CLLocationCoordinate2D(latitude: 30.5051, longitude: -87.8964)
                                locationName = "Fairhope Pier"
                            }

                            QuickLocationButton(name: "Daphne") {
                                selectedLocation = CLLocationCoordinate2D(latitude: 30.5234, longitude: -87.8812)
                                locationName = "Daphne"
                            }

                            QuickLocationButton(name: "Battles Wharf") {
                                selectedLocation = CLLocationCoordinate2D(latitude: 30.4921, longitude: -87.9156)
                                locationName = "Battles Wharf"
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Quick Location Button

struct QuickLocationButton: View {
    let name: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(name)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Report Details View

struct ReportDetailsView: View {
    @Binding var selectedSpecies: Set<String>
    @Binding var intensity: ReportIntensity
    @Binding var reportDescription: String
    @Binding var selectedPhotos: [UIImage]

    let availableSpecies = ["Blue Crab", "Flounder", "Shrimp", "Mullet", "Eel", "Stingray", "Catfish"]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Provide details about the jubilee")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 16) {
                // Species selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Species Observed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    FlowLayout(spacing: 8) {
                        ForEach(availableSpecies, id: \.self) { species in
                            SpeciesToggleButton(
                                species: species,
                                isSelected: selectedSpecies.contains(species)
                            ) {
                                if selectedSpecies.contains(species) {
                                    selectedSpecies.remove(species)
                                } else {
                                    selectedSpecies.insert(species)
                                }
                            }
                        }
                    }
                }

                Divider()

                // Intensity selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Picker("Intensity", selection: $intensity) {
                        Text("Low").tag(ReportIntensity.low)
                        Text("Moderate").tag(ReportIntensity.moderate)
                        Text("Heavy").tag(ReportIntensity.heavy)
                        Text("Extreme").tag(ReportIntensity.extreme)
                    }
                    .pickerStyle(.segmented)
                }

                Divider()

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description (Optional)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    TextEditor(text: $reportDescription)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Divider()

                // Photos (placeholder)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Photos (Optional)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Button {
                        // TODO: Photo picker
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                            Text("Add Photos")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

// MARK: - Species Toggle Button

struct SpeciesToggleButton: View {
    let species: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(species)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(red: 30/255, green: 64/255, blue: 175/255) : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

// MARK: - Report Review View

struct ReportReviewView: View {
    let reportType: ReportType
    let locationName: String
    let selectedSpecies: Set<String>
    let intensity: ReportIntensity
    let reportDescription: String
    let photoCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Review your report")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)

            VStack(spacing: 16) {
                ReviewRow(title: "Report Type", value: reportType.rawValue, icon: "doc.text.fill")
                ReviewRow(title: "Location", value: locationName, icon: "mappin.circle.fill")
                ReviewRow(title: "Species", value: selectedSpecies.sorted().joined(separator: ", "), icon: "list.bullet")
                ReviewRow(title: "Intensity", value: intensityText, icon: "gauge.with.dots.needle.50percent")

                if !reportDescription.isEmpty {
                    ReviewRow(title: "Description", value: reportDescription, icon: "text.quote")
                }

                if photoCount > 0 {
                    ReviewRow(title: "Photos", value: "\(photoCount) photo(s)", icon: "photo.fill")
                }
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Important")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Text("By submitting this report, you confirm that the information provided is accurate to the best of your knowledge. False reports may result in account suspension.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }

    private var intensityText: String {
        switch intensity {
        case .low: return "Low"
        case .moderate: return "Moderate"
        case .heavy: return "Heavy"
        case .extreme: return "Extreme"
        }
    }
}

// MARK: - Review Row

struct ReviewRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)

                Text(value)
                    .font(.subheadline)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview {
    ReportSubmissionView()
}
