//
//  DashboardViewModel.swift
//  PushLogic
//
//  View model for the Home dashboard. Reads from the activity and
//  challenge repositories, runs roll-ups through StatisticsService, and
//  exposes view-ready values for the existing dashboard components.
//

import Foundation

@MainActor
@Observable
final class DashboardViewModel {
    // MARK: Dependencies

    private let challenges: any ChallengeRepositoryProtocol
    private let activities: any ActivityRepositoryProtocol
    private let statistics: StatisticsService
    private let calendar: Calendar

    // MARK: Today's progress

    var todayPushups: Int = 0
    var todayGoal: Int = 200
    var currentStreak: Int = 0

    // MARK: Statistics row

    var dayStreak: Int = 0
    var bestDay: Int = 0
    var thisWeek: Int = 0

    // MARK: Weekly streak

    var weekDays: [WeeklyStreakCard.Day] = []

    // MARK: Activity chart

    var weeklyChartData: [ActivityChartCard.DataPoint] = []
    var monthlyChartData: [ActivityChartCard.DataPoint] = []

    // MARK: Active challenges

    var activeChallenges: [Challenge] = []

    // MARK: Init

    init(
        challenges: any ChallengeRepositoryProtocol,
        activities: any ActivityRepositoryProtocol,
        statistics: StatisticsService = StatisticsService(),
        calendar: Calendar = .current
    ) {
        self.challenges = challenges
        self.activities = activities
        self.statistics = statistics
        self.calendar = calendar
    }

    // MARK: Refresh

    func refresh() {
        do {
            let allActivity = try activities.fetchAll()
            let dailyTotals = statistics.dailyTotals(in: allActivity)

            todayPushups = try activities.dailyTotal(on: .now)
            currentStreak = statistics.currentStreak(in: allActivity, today: .now)
            dayStreak = currentStreak
            bestDay = dailyTotals.values.max() ?? 0
            thisWeek = try activities.weeklyTotal(containing: .now)

            weekDays = computeWeekDays(activeDays: Set(dailyTotals.keys))
            weeklyChartData = computeWeeklyChart()
            monthlyChartData = computeMonthlyChart()

            activeChallenges = try challenges.fetchActive()
        } catch {
            print("DashboardViewModel.refresh failed: \(error)")
        }
    }

    // MARK: Helpers

    private func computeWeekDays(activeDays: Set<Date>) -> [WeeklyStreakCard.Day] {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: .now) else { return [] }
        let letters = ["M", "T", "W", "T", "F", "S", "S"]
        let today = calendar.startOfDay(for: .now)

        var result: [WeeklyStreakCard.Day] = []
        var day = week.start
        for letter in letters {
            let dayStart = calendar.startOfDay(for: day)
            let state: DayCircle.DayState
            if activeDays.contains(dayStart) {
                state = .completed
            } else if calendar.isDate(dayStart, inSameDayAs: today) {
                state = .current
            } else {
                state = .future
            }
            result.append(.init(letter: letter, state: state))
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? day
        }
        return result
    }

    private func computeWeeklyChart() -> [ActivityChartCard.DataPoint] {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: .now) else { return [] }
        let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let today = calendar.startOfDay(for: .now)

        var result: [ActivityChartCard.DataPoint] = []
        var day = week.start
        for label in labels {
            let dayStart = calendar.startOfDay(for: day)
            let value = (try? activities.dailyTotal(on: dayStart)) ?? 0
            result.append(
                .init(
                    label: label,
                    value: value,
                    isCurrent: calendar.isDate(dayStart, inSameDayAs: today)
                )
            )
            day = calendar.date(byAdding: .day, value: 1, to: day) ?? day
        }
        return result
    }

    private func computeMonthlyChart() -> [ActivityChartCard.DataPoint] {
        let weeksToShow = 4
        var result: [ActivityChartCard.DataPoint] = []
        for offset in (0..<weeksToShow).reversed() {
            let weekDate = calendar.date(byAdding: .weekOfYear, value: -offset, to: .now) ?? .now
            let value = (try? activities.weeklyTotal(containing: weekDate)) ?? 0
            let label = "W\(weeksToShow - offset)"
            result.append(.init(label: label, value: value, isCurrent: offset == 0))
        }
        return result
    }
}
