//
//  NetworkProfilesMenueBarApp.swift
//  NetworkProfilesMenueBar
//
//  Created by Nico Mattes on 14.01.25.
//

import SwiftUI
import SwiftData

struct NetworkProfilesMenueBarApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
