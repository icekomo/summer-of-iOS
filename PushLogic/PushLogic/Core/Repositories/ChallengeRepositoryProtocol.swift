//
//  ChallengeRepositoryProtocol.swift
//  PushLogic
//
//  Abstraction over Challenge persistence. ViewModels depend on this
//  protocol so storage backends (SwiftData today, CloudKit later) can
//  be swapped without touching the rest of the app.
//

import Foundation

protocol ChallengeRepositoryProtocol: AnyObject {
    /// Insert a new challenge and persist.
    func create(_ challenge: Challenge) throws

    /// Delete a challenge and persist.
    func delete(_ challenge: Challenge) throws

    /// Commit pending mutations made directly on a fetched challenge.
    func save() throws

    /// All challenges, newest first.
    func fetchAll() throws -> [Challenge]

    /// Challenges that have not been completed and have not ended.
    func fetchActive() throws -> [Challenge]

    /// Look up a specific challenge by id.
    func fetch(id: UUID) throws -> Challenge?

    /// Mark a challenge as completed and persist.
    func finish(_ challenge: Challenge) throws
}
