//
//  MovieListingAppApp.swift
//  MovieListingApp
//
//  Created by TTHQ23-PANGWENHUEI on 01/04/2026.
//

import SwiftUI
import SwiftData

@main
struct MovieListingAppApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Movie.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
//        .modelContainer(sharedModelContainer)
    }
}
