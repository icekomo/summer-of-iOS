//
//  UserSettings.swift
//  PushLogic
//
//  Persisted user preferences. Treated as a single-row record by the
//  SettingsRepository.
//

import Foundation
import SwiftData

enum ColorTheme: String, Codable, CaseIterable {
    case system
    case light
    case dark
}

@Model
final class UserSettings {
    var id: UUID
    var notificationsEnabled: Bool
    var hapticsEnabled: Bool
    var theme: ColorTheme
    var dailyReminder: Date?
    var displayName: String

    init(
        id: UUID = UUID(),
        notificationsEnabled: Bool = true,
        hapticsEnabled: Bool = true,
        theme: ColorTheme = .system,
        dailyReminder: Date? = nil,
        displayName: String = ""
    ) {
        self.id = id
        self.notificationsEnabled = notificationsEnabled
        self.hapticsEnabled = hapticsEnabled
        self.theme = theme
        self.dailyReminder = dailyReminder
        self.displayName = displayName
    }

    // MARK: Computed

    var hasDailyReminder: Bool {
        dailyReminder != nil
    }
}
