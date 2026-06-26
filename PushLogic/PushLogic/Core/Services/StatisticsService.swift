//
//  StatisticsService.swift
//  PushLogic
//
//  Pure-function computations over ActivityRecord arrays. Holds no state
//  and reads no persistence — callers fetch records from the repository
//  and pass them in.
//

import Foundation

final class StatisticsService {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    // MARK: Totals

    /// Sum of push-ups across all supplied records.
    func total(in records: [ActivityRecord]) -> Int {
        records.reduce(0) { $0 + $1.pushups }
    }

    /// Average push-ups per active day (days with at least one record).
    func dailyAverage(in records: [ActivityRecord]) -> Double {
        let totals = dailyTotals(in: records)
        guard !totals.isEmpty else { return 0 }
        let sum = totals.values.reduce(0, +)
        return Double(sum) / Double(totals.count)
    }

    // MARK: Buckets

    /// Totals bucketed by calendar day, keyed by start-of-day.
    func dailyTotals(in records: [ActivityRecord]) -> [Date: Int] {
        var totals: [Date: Int] = [:]
        for record in records {
            let key = calendar.startOfDay(for: record.date)
            totals[key, default: 0] += record.pushups
        }
        return totals
    }

    /// Totals bucketed by calendar week, keyed by start-of-week.
    func weeklyTotals(in records: [ActivityRecord]) -> [Date: Int] {
        var totals: [Date: Int] = [:]
        for record in records {
            guard let week = calendar.dateInterval(of: .weekOfYear, for: record.date) else {
                continue
            }
            totals[week.start, default: 0] += record.pushups
        }
        return totals
    }

    /// Totals bucketed by calendar month, keyed by start-of-month.
    func monthlyTotals(in records: [ActivityRecord]) -> [Date: Int] {
        var totals: [Date: Int] = [:]
        for record in records {
            guard let month = calendar.dateInterval(of: .month, for: record.date) else {
                continue
            }
            totals[month.start, default: 0] += record.pushups
        }
        return totals
    }

    // MARK: Streaks

    /// Longest run of consecutive days with at least one record.
    func longestStreak(in records: [ActivityRecord]) -> Int {
        let days = Set(records.map { calendar.startOfDay(for: $0.date) }).sorted()
        guard !days.isEmpty else { return 0 }

        var longest = 1
        var current = 1
        for index in 1..<days.count {
            guard let next = calendar.date(byAdding: .day, value: 1, to: days[index - 1]) else {
                current = 1
                continue
            }
            if calendar.isDate(next, inSameDayAs: days[index]) {
                current += 1
                longest = max(longest, current)
            } else {
                current = 1
            }
        }
        return longest
    }

    /// Current streak ending today, or yesterday if no activity logged today yet.
    func currentStreak(in records: [ActivityRecord], today: Date = .now) -> Int {
        let days = Set(records.map { calendar.startOfDay(for: $0.date) })
        guard !days.isEmpty else { return 0 }

        let startOfToday = calendar.startOfDay(for: today)
        let initialAnchor: Date? = days.contains(startOfToday)
            ? startOfToday
            : calendar.date(byAdding: .day, value: -1, to: startOfToday)

        guard var anchor = initialAnchor, days.contains(anchor) else { return 0 }

        var streak = 0
        while days.contains(anchor) {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: anchor) else { break }
            anchor = previous
        }
        return streak
    }
}
