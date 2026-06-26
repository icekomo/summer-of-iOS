//
//  ActivityRepositoryProtocol.swift
//  PushLogic
//
//  Abstraction over ActivityRecord persistence and roll-ups.
//

import Foundation

protocol ActivityRepositoryProtocol: AnyObject {
    /// Insert a new activity record and persist.
    func save(_ record: ActivityRecord) throws

    /// Delete an activity record and persist.
    func delete(_ record: ActivityRecord) throws

    /// All activity records, newest first.
    func fetchAll() throws -> [ActivityRecord]

    /// Records belonging to a specific challenge.
    func fetchRecords(for challenge: Challenge) throws -> [ActivityRecord]

    /// Records within a date range (inclusive `start`, exclusive `end`).
    func fetchRecords(from start: Date, to end: Date) throws -> [ActivityRecord]

    /// Sum of push-ups recorded on the given calendar day.
    func dailyTotal(on date: Date) throws -> Int

    /// Sum of push-ups recorded in the calendar week containing the date.
    func weeklyTotal(containing date: Date) throws -> Int

    /// Day-bucketed totals across a range, keyed by start-of-day.
    func dailyTotals(from start: Date, to end: Date) throws -> [Date: Int]
}
