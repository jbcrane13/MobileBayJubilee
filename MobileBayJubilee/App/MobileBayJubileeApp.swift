//
//  MobileBayJubileeApp.swift
//  MobileBayJubilee
//
//  Created by Claude Code on 2025-10-18.
//  Mobile Bay Jubilee Community Intelligence Platform
//  Target: iOS 17.0+
//

import SwiftUI
import SwiftData

@main
struct MobileBayJubileeApp: App {
    // MARK: - SwiftData Model Container

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            JubileeReport.self,
            ConditionData.self,
            Location.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
