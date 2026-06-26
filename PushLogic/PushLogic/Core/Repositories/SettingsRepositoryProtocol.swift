//
//  SettingsRepositoryProtocol.swift
//  PushLogic
//
//  Abstraction over the single UserSettings record.
//

import Foundation

protocol SettingsRepositoryProtocol: AnyObject {
    /// Returns the singleton settings record, creating it on first access.
    func load() throws -> UserSettings

    /// Commit pending mutations made directly on the loaded settings.
    func save() throws
}
