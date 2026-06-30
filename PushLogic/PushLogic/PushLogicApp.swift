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
    let modelContainer: ModelContainer
    let appEnvironment: AppEnvironment

    @State private var hasFinishedSplash = false

    init() {
        let schema = Schema([
            Item.self,
            Challenge.self,
            Participant.self,
            ActivityRecord.self,
            Achievement.self,
            UserSettings.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        let container: ModelContainer
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        self.modelContainer = container

        let context = container.mainContext
        let repositories = RepositoryContainer(
            challenges: ChallengeRepository(context: context),
            activities: ActivityRepository(context: context),
            settings: SettingsRepository(context: context)
        )
        self.appEnvironment = AppEnvironment(
            repositories: repositories,
            router: AppRouter()
        )
    }

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
            .preferredColorScheme(.dark)
            .environment(appEnvironment)
        }
        .modelContainer(modelContainer)
    }
}
