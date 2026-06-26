//
//  SettingsRepository.swift
//  PushLogic
//
//  SwiftData-backed implementation of SettingsRepositoryProtocol.
//  Treats UserSettings as a singleton row, creating it on first load.
//

import Foundation
import SwiftData

final class SettingsRepository: SettingsRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func load() throws -> UserSettings {
        var descriptor = FetchDescriptor<UserSettings>()
        descriptor.fetchLimit = 1
        if let existing = try context.fetch(descriptor).first {
            return existing
        }
        let fresh = UserSettings()
        context.insert(fresh)
        try context.save()
        return fresh
    }

    func save() throws {
        try context.save()
    }
}
