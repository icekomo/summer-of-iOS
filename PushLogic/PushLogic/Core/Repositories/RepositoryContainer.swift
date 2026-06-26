//
//  RepositoryContainer.swift
//  PushLogic
//
//  Aggregates repository dependencies for injection through AppEnvironment.
//

import Foundation

@Observable
final class RepositoryContainer {
    let challenges: any ChallengeRepositoryProtocol
    let activities: any ActivityRepositoryProtocol
    let settings: any SettingsRepositoryProtocol

    init(
        challenges: any ChallengeRepositoryProtocol,
        activities: any ActivityRepositoryProtocol,
        settings: any SettingsRepositoryProtocol
    ) {
        self.challenges = challenges
        self.activities = activities
        self.settings = settings
    }
}
