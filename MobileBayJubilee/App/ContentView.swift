//
//  ContentView.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 2025-10-18.
//  Main app navigation using TabView
//

import SwiftUI

struct ContentView: View {
    // MARK: - State

    @State private var selectedTab: Tab = .dashboard

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "gauge.with.dots.needle.bottom.50percent")
                }
                .tag(Tab.dashboard)

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(Tab.map)

            CommunityPlaceholderView()
                .tabItem {
                    Label("Community", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(Tab.community)

            ProfilePlaceholderView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
    }
}

// MARK: - Tab Enum

enum Tab {
    case dashboard
    case map
    case community
    case profile
}

// MARK: - Placeholder Views

struct DashboardPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "gauge.with.dots.needle.bottom.50percent")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)

                Text("Conditions Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Phase 0 - Foundation")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("Ready for P1 development")
                    .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct MapPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "map.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.green)

                Text("Jubilee Map")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Phase 0 - Foundation")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("Ready for P1 development")
                    .padding()
            }
            .navigationTitle("Map")
        }
    }
}

struct CommunityPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.purple)

                Text("Community")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Phase 0 - Foundation")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("Ready for P1 development")
                    .padding()
            }
            .navigationTitle("Community")
        }
    }
}

struct ProfilePlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "person.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.orange)

                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Phase 0 - Foundation")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                Text("Ready for P1 development")
                    .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
