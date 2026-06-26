//
//  ChallengeRepository.swift
//  PushLogic
//
//  SwiftData-backed implementation of ChallengeRepositoryProtocol.
//

import Foundation
import SwiftData

final class ChallengeRepository: ChallengeRepositoryProtocol {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func create(_ challenge: Challenge) throws {
        context.insert(challenge)
        try context.save()
    }

    func delete(_ challenge: Challenge) throws {
        context.delete(challenge)
        try context.save()
    }

    func save() throws {
        try context.save()
    }

    func fetchAll() throws -> [Challenge] {
        let descriptor = FetchDescriptor<Challenge>(
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func fetchActive() throws -> [Challenge] {
        let now = Date.now
        let predicate = #Predicate<Challenge> { challenge in
            !challenge.isCompleted && challenge.endDate >= now
        }
        let descriptor = FetchDescriptor<Challenge>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.endDate)]
        )
        return try context.fetch(descriptor)
    }

    func fetch(id: UUID) throws -> Challenge? {
        let predicate = #Predicate<Challenge> { $0.id == id }
        var descriptor = FetchDescriptor<Challenge>(predicate: predicate)
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func finish(_ challenge: Challenge) throws {
        challenge.isCompleted = true
        try context.save()
    }
}
