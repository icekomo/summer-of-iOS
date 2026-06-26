//
//  NotificationService.swift
//  PushLogic
//
//  Wraps UNUserNotificationCenter for daily reminders and
//  challenge-lifecycle alerts. Does not touch persistence — callers pass
//  in the values needed to render each notification.
//

import Foundation
import UserNotifications

final class NotificationService {
    private let center: UNUserNotificationCenter
    private let calendar: Calendar

    init(
        center: UNUserNotificationCenter = .current(),
        calendar: Calendar = .current
    ) {
        self.center = center
        self.calendar = calendar
    }

    // MARK: Authorization

    /// Requests alert, sound, and badge permissions. Returns whether granted.
    @discardableResult
    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    // MARK: Scheduling

    /// Schedules a repeating daily reminder at the hour/minute of `time`.
    func scheduleDailyReminder(at time: Date) {
        cancel(identifier: Identifier.dailyReminder)

        let components = calendar.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Time to push"
        content.body = "Knock out a set of push-ups."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: Identifier.dailyReminder,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    /// Schedules a one-shot reminder the day before a challenge ends.
    func scheduleChallengeEndingReminder(
        challengeID: UUID,
        title: String,
        endDate: Date
    ) {
        let identifier = Identifier.challengeEnding(challengeID)
        cancel(identifier: identifier)

        guard
            let triggerDate = calendar.date(byAdding: .day, value: -1, to: endDate),
            triggerDate > .now
        else {
            return
        }

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: triggerDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "One day left"
        content.body = "Finish strong on \(title)."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    /// Delivers an immediate completion notification for a challenge.
    func notifyChallengeCompleted(challengeID: UUID, title: String) {
        let identifier = Identifier.challengeCompleted(challengeID)

        let content = UNMutableNotificationContent()
        content.title = "Challenge complete"
        content.body = "You crushed \(title)."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    // MARK: Cancellation

    func cancel(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }

    // MARK: Identifiers

    private enum Identifier {
        static let dailyReminder = "pushlogic.dailyReminder"

        static func challengeEnding(_ id: UUID) -> String {
            "pushlogic.challengeEnding.\(id.uuidString)"
        }

        static func challengeCompleted(_ id: UUID) -> String {
            "pushlogic.challengeCompleted.\(id.uuidString)"
        }
    }
}
