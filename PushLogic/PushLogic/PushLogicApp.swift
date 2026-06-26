//
//  PushLogicApp.swift
//  PushLogic
//
//  Created by Josh Gdovin on 6/25/26.
//

import SwiftUI
import SwiftData

@main
struct PushLogicApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @State private var hasFinishedSplash = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if hasFinishedSplash {
                    RootView()
                        .transition(.opacity)
                } else {
                    SplashView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            hasFinishedSplash = true
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
