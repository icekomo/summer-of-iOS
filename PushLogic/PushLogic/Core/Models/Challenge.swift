//
//  Challenge.swift
//  PushLogic
//
//  A user-defined push-up challenge: a goal, a window, and the
//  participants and activity that contribute toward it.
//

import Foundation
import SwiftData

@Model
final class Challenge {
    var id: UUID
    var title: String
    var goalPushups: Int
    var currentPushups: Int
    var startDate: Date
    var endDate: Date
    var createdDate: Date
    var isCompleted: Bool

    @Relationship(deleteRule: .cascade, inverse: \Participant.challenge)
    var participants: [Participant] = []

    @Relationship(deleteRule: .cascade, inverse: \ActivityRecord.challenge)
    var activities: [ActivityRecord] = []

    init(
        id: UUID = UUID(),
        title: String,
        goalPushups: Int,
        currentPushups: Int = 0,
        startDate: Date = .now,
        endDate: Date,
        createdDate: Date = .now,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.goalPushups = goalPushups
        self.currentPushups = currentPushups
        self.startDate = startDate
        self.endDate = endDate
        self.createdDate = createdDate
        self.isCompleted = isCompleted
    }

    // MARK: Computed

    /// Fraction of the goal completed, clamped to 0...1.
    var progress: Double {
        guard goalPushups > 0 else { return 0 }
        return min(1, max(0, Double(currentPushups) / Double(goalPushups)))
    }

    /// Push-ups still owed toward the goal.
    var remainingPushups: Int {
        max(0, goalPushups - currentPushups)
    }

    /// Whole days from today until `endDate`, never negative.
    var daysRemaining: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: .now)
        let end = calendar.startOfDay(for: endDate)
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 0
        return max(0, days)
    }

    /// 0...100 integer percentage for display.
    var completionPercentage: Int {
        Int((progress * 100).rounded())
    }

    /// Still in progress and not past its end date.
    var isActive: Bool {
        !isCompleted && Date.now <= endDate
    }

    /// End date is in the past.
    var hasEnded: Bool {
        Date.now > endDate
    }
}
