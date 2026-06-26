//
//  AchievementService.swift
//  PushLogic
//
//  Decides which achievements should be awarded for a given activity
//  history. Pure logic — callers persist the returned achievements via
//  the repository.
//

import Foundation

struct AchievementDefinition {
    /// Stable identifier used to dedupe against already-earned achievements.
    let identifier: String
    let title: String
    let icon: String
    let type: AchievementType
}

final class AchievementService {
    private let statistics: StatisticsService
    private let definitions: [AchievementDefinition]

    init(
        statistics: StatisticsService = StatisticsService(),
        definitions: [AchievementDefinition] = AchievementService.defaultDefinitions
    ) {
        self.statistics = statistics
        self.definitions = definitions
    }

    /// Returns definitions whose unlock condition is met by the current
    /// activity history but which have not yet been earned.
    func newlyEarned(
        from records: [ActivityRecord],
        existing: [Achievement]
    ) -> [AchievementDefinition] {
        let total = statistics.total(in: records)
        let longest = statistics.longestStreak(in: records)
        let earnedTitles = Set(existing.map(\.title))

        return definitions.filter { definition in
            guard !earnedTitles.contains(definition.title) else { return false }
            return isUnlocked(definition, total: total, longestStreak: longest)
        }
    }

    /// Builds an Achievement instance from a definition. Caller is
    /// responsible for persisting it via the achievement repository.
    func makeAchievement(from definition: AchievementDefinition, on date: Date = .now) -> Achievement {
        Achievement(
            title: definition.title,
            icon: definition.icon,
            dateEarned: date,
            type: definition.type
        )
    }

    // MARK: Rules

    private func isUnlocked(
        _ definition: AchievementDefinition,
        total: Int,
        longestStreak: Int
    ) -> Bool {
        switch definition.identifier {
        case Identifier.milestone100: return total >= 100
        case Identifier.milestone500: return total >= 500
        case Identifier.milestone1000: return total >= 1000
        case Identifier.streak7: return longestStreak >= 7
        default: return false
        }
    }

    // MARK: Defaults

    private enum Identifier {
        static let milestone100 = "milestone_100"
        static let milestone500 = "milestone_500"
        static let milestone1000 = "milestone_1000"
        static let streak7 = "streak_7"
    }

    static let defaultDefinitions: [AchievementDefinition] = [
        .init(
            identifier: Identifier.milestone100,
            title: "First 100 Push-ups",
            icon: "medal.fill",
            type: .pushupMilestone
        ),
        .init(
            identifier: Identifier.milestone500,
            title: "500 Push-ups",
            icon: "trophy.fill",
            type: .pushupMilestone
        ),
        .init(
            identifier: Identifier.milestone1000,
            title: "1000 Push-ups",
            icon: "rosette",
            type: .pushupMilestone
        ),
        .init(
            identifier: Identifier.streak7,
            title: "7-Day Streak",
            icon: "flame.fill",
            type: .streak
        )
    ]
}
