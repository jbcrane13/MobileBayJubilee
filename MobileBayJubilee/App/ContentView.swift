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

            CommunityView()
                .tabItem {
                    Label("Community", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(Tab.community)

            ProfileView()
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

// MARK: - Preview

#Preview {
    ContentView()
}
