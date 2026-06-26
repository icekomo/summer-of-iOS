//
//  ActivityRepository.swift
//  PushLogic
//
//  SwiftData-backed implementation of ActivityRepositoryProtocol.
//

import Foundation
import SwiftData

final class ActivityRepository: ActivityRepositoryProtocol {
    private let context: ModelContext
    private let calendar: Calendar

    init(context: ModelContext, calendar: Calendar = .current) {
        self.context = context
        self.calendar = calendar
    }

    func save(_ record: ActivityRecord) throws {
        context.insert(record)
        try context.save()
    }

    func delete(_ record: ActivityRecord) throws {
        context.delete(record)
        try context.save()
    }

    func fetchAll() throws -> [ActivityRecord] {
        let descriptor = FetchDescriptor<ActivityRecord>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func fetchRecords(for challenge: Challenge) throws -> [ActivityRecord] {
        let challengeID = challenge.id
        let predicate = #Predicate<ActivityRecord> { record in
            record.challenge?.id == challengeID
        }
        let descriptor = FetchDescriptor<ActivityRecord>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }

    func fetchRecords(from start: Date, to end: Date) throws -> [ActivityRecord] {
        let predicate = #Predicate<ActivityRecord> { record in
            record.date >= start && record.date < end
        }
        let descriptor = FetchDescriptor<ActivityRecord>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date)]
        )
        return try context.fetch(descriptor)
    }

    func dailyTotal(on date: Date) throws -> Int {
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return 0
        }
        return try fetchRecords(from: startOfDay, to: endOfDay)
            .reduce(0) { $0 + $1.pushups }
    }

    func weeklyTotal(containing date: Date) throws -> Int {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return 0
        }
        return try fetchRecords(from: week.start, to: week.end)
            .reduce(0) { $0 + $1.pushups }
    }

    func dailyTotals(from start: Date, to end: Date) throws -> [Date: Int] {
        let records = try fetchRecords(from: start, to: end)
        var totals: [Date: Int] = [:]
        for record in records {
            let key = calendar.startOfDay(for: record.date)
            totals[key, default: 0] += record.pushups
        }
        return totals
    }
}
