//
//  Participant.swift
//  PushLogic
//
//  Someone contributing push-ups toward a Challenge. `appleUserID` is
//  reserved for future CloudKit / shared-challenge support.
//

import Foundation
import SwiftData

@Model
final class Participant {
    var id: UUID
    var name: String
    var avatar: String?
    var progress: Int
    var appleUserID: String?

    var challenge: Challenge?

    init(
        id: UUID = UUID(),
        name: String,
        avatar: String? = nil,
        progress: Int = 0,
        appleUserID: String? = nil
    ) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.progress = progress
        self.appleUserID = appleUserID
    }

    // MARK: Computed

    /// Up to two uppercase initials drawn from `name`.
    var initials: String {
        let parts = name
            .split(whereSeparator: { $0.isWhitespace })
            .compactMap { $0.first.map(String.init) }
        let first = parts.first ?? ""
        let last = parts.count > 1 ? (parts.last ?? "") : ""
        return (first + last).uppercased()
    }

    /// 0...100 share of this participant against the parent challenge goal.
    var completionPercentage: Int {
        guard let goal = challenge?.goalPushups, goal > 0 else { return 0 }
        return min(100, Int((Double(progress) / Double(goal) * 100).rounded()))
    }
}
