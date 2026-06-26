//
//  ActivityRecord.swift
//  PushLogic
//
//  A single workout entry. May or may not belong to a Challenge —
//  freestyle sets are valid history too.
//

import Foundation
import SwiftData

@Model
final class ActivityRecord {
    var id: UUID
    var date: Date
    var pushups: Int

    var challenge: Challenge?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        pushups: Int,
        challenge: Challenge? = nil
    ) {
        self.id = id
        self.date = date
        self.pushups = pushups
        self.challenge = challenge
    }

    // MARK: Computed

    /// Calendar-day bucket used by daily / weekly aggregations.
    var dayKey: Date {
        Calendar.current.startOfDay(for: date)
    }
}
