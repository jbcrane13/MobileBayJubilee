//
//  ProfileView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 10/18/25.
//  Phase 1 - Month 1: User profile and settings screen
//

import SwiftUI

struct ProfileView: View {
    @State private var isSignedIn = false
    @State private var notificationsEnabled = true
    @State private var notificationThreshold = 70.0
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if isSignedIn {
                        // Signed In State
                        SignedInProfileView(
                            notificationsEnabled: $notificationsEnabled,
                            notificationThreshold: $notificationThreshold
                        )
                    } else {
                        // Sign In Prompt
                        SignInPromptView(isSignedIn: $isSignedIn)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if isSignedIn {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

// MARK: - Signed In Profile View

struct SignedInProfileView: View {
    @Binding var notificationsEnabled: Bool
    @Binding var notificationThreshold: Double

    var body: some View {
        VStack(spacing: 24) {
            // MARK: - Profile Header
            VStack(spacing: 16) {
                // Avatar
                Circle()
                    .fill(Color.appPrimary.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.appPrimary)
                    }

                VStack(spacing: 4) {
                    Text("Jubilee Watcher") // TODO: Replace with actual user name
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("member@example.com") // TODO: Replace with actual email
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // Reputation badge
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)

                    Text("50 Reputation") // TODO: Replace with actual reputation
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .clipShape(Capsule())
            }
            .padding(.vertical)

            // MARK: - Stats Section
            HStack(spacing: 0) {
                StatBox(title: "Reports", value: "0") // TODO: Replace with actual count
                Divider()
                StatBox(title: "Verifications", value: "0") // TODO: Replace with actual count
                Divider()
                StatBox(title: "Days Active", value: "1") // TODO: Replace with actual count
            }
            .frame(height: 80)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // MARK: - Notification Settings
            VStack(alignment: .leading, spacing: 16) {
                Text("Notification Settings")
                    .font(.headline)

                VStack(spacing: 16) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)

                    if notificationsEnabled {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Alert Threshold: \(Int(notificationThreshold))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Slider(value: $notificationThreshold, in: 0...100, step: 5)

                            Text("Notify me when Condition Score reaches \(Int(notificationThreshold)) or higher")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // MARK: - Quick Actions
            VStack(alignment: .leading, spacing: 12) {
                Text("Quick Actions")
                    .font(.headline)

                VStack(spacing: 12) {
                    NavigationLink {
                        // TODO: My Reports View
                        Text("My Reports")
                    } label: {
                        ProfileActionRow(icon: "doc.text.fill", title: "My Reports", badge: "0")
                    }

                    NavigationLink {
                        // TODO: Favorite Locations View
                        Text("Favorite Locations")
                    } label: {
                        ProfileActionRow(icon: "mappin.circle.fill", title: "Favorite Locations", badge: nil)
                    }

                    NavigationLink {
                        // TODO: Notification History View
                        Text("Notification History")
                    } label: {
                        ProfileActionRow(icon: "bell.fill", title: "Notification History", badge: nil)
                    }
                }
            }

            // MARK: - Account Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Account")
                    .font(.headline)

                VStack(spacing: 12) {
                    Button {
                        // TODO: Edit Profile
                    } label: {
                        ProfileActionRow(icon: "pencil.circle.fill", title: "Edit Profile", badge: nil)
                    }

                    Button {
                        // TODO: Privacy Settings
                    } label: {
                        ProfileActionRow(icon: "lock.fill", title: "Privacy Settings", badge: nil)
                    }

                    Button(role: .destructive) {
                        // TODO: Sign out
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right.square.fill")
                                .foregroundColor(.red)

                            Text("Sign Out")
                                .foregroundColor(.red)

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
}

// MARK: - Stat Box

struct StatBox: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Profile Action Row

struct ProfileActionRow: View {
    let icon: String
    let title: String
    let badge: String?

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)
                .frame(width: 24)

            Text(title)
                .foregroundColor(.primary)

            Spacer()

            if let badge = badge {
                Text(badge)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.appPrimary.opacity(0.2))
                    .foregroundColor(.appPrimary)
                    .clipShape(Capsule())
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Sign In Prompt View

struct SignInPromptView: View {
    @Binding var isSignedIn: Bool

    var body: some View {
        VStack(spacing: 24) {
            // Icon
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.appPrimary)

            VStack(spacing: 8) {
                Text("Sign In to JubileeHub")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Create an account to submit reports, verify sightings, and receive notifications")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            VStack(spacing: 12) {
                // Sign in with Apple
                Button {
                    // TODO: Implement Sign in with Apple
                    isSignedIn = true // Temporary for development
                } label: {
                    HStack {
                        Image(systemName: "applelogo")
                        Text("Sign in with Apple")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Email sign in
                Button {
                    // TODO: Implement Email sign in
                    isSignedIn = true // Temporary for development
                } label: {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("Sign in with Email")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.appPrimary)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal)

            // Browse without signing in
            Button {
                // User can browse without account
            } label: {
                Text("Continue without signing in")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()
                .padding(.vertical)

            // Benefits list
            VStack(alignment: .leading, spacing: 16) {
                Text("Member Benefits")
                    .font(.headline)

                BenefitRow(icon: "doc.badge.plus", title: "Submit jubilee reports")
                BenefitRow(icon: "checkmark.seal.fill", title: "Verify community reports")
                BenefitRow(icon: "bell.badge.fill", title: "Receive condition alerts")
                BenefitRow(icon: "mappin.circle.fill", title: "Save favorite locations")
                BenefitRow(icon: "star.fill", title: "Build reputation")
            }
        }
        .padding(.vertical, 40)
    }
}

// MARK: - Benefit Row

struct BenefitRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)
                .frame(width: 24)

            Text(title)
                .font(.subheadline)
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    NavigationLink {
                        Text("Account Settings")
                    } label: {
                        Label("Account", systemImage: "person.fill")
                    }

                    NavigationLink {
                        Text("Notification Settings")
                    } label: {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                }

                Section("About") {
                    NavigationLink {
                        Text("About JubileeHub")
                    } label: {
                        Label("About", systemImage: "info.circle.fill")
                    }

                    NavigationLink {
                        Text("Privacy Policy")
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                    }

                    NavigationLink {
                        Text("Terms of Service")
                    } label: {
                        Label("Terms of Service", systemImage: "doc.text.fill")
                    }
                }

                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0") // TODO: Get from bundle
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Signed Out") {
    ProfileView()
}

#Preview("Dark Mode") {
    ProfileView()
        .preferredColorScheme(.dark)
}
