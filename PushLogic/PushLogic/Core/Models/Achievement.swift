//
//  Achievement.swift
//  PushLogic
//
//  An earned badge — milestones, streaks, and challenge completions.
//

import Foundation
import SwiftData

enum AchievementType: String, Codable, CaseIterable {
    case pushupMilestone
    case streak
    case challengeCompleted
    case firstChallenge
}

@Model
final class Achievement {
    var id: UUID
    var title: String
    var icon: String
    var dateEarned: Date
    var type: AchievementType

    init(
        id: UUID = UUID(),
        title: String,
        icon: String,
        dateEarned: Date = .now,
        type: AchievementType
    ) {
        self.id = id
        self.title = title
        self.icon = icon
        self.dateEarned = dateEarned
        self.type = type
    }
}
