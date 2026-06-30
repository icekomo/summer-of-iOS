//
//  ChallengeCard.swift
//  PushLogic
//
//  Rich challenge card for the dashboard's "Push Groups" section.
//  Supports Active / Completed / Future states; renders status, days
//  remaining, title, optional leaderboard, participant avatars or
//  warning text, and a primary action button. Pure presentation — no
//  business logic, no persistence.
//

import SwiftUI

struct ChallengeCard: View {
    // MARK: Public types

    enum Status: Equatable {
        case active(daysRemaining: Int)
        case completed
        case future(daysUntilStart: Int)
    }

    struct LeaderboardEntry: Identifiable {
        let id = UUID()
        let rank: Int
        let name: String
        let avatar: AvatarView.Source
        let score: Int
        let progress: Double
        var isCurrentUser: Bool = false
        var barTint: Color? = nil
    }

    struct Warning {
        let icon: String
        let text: String
        var tint: Color = Color(red: 0.96, green: 0.78, blue: 0.30)
    }

    // MARK: Inputs

    let title: String
    let status: Status
    var rank: Int? = nil
    var rankLabel: String = "Your Rank"
    var rankTint: Color = AppColors.accent
    var leaderboard: [LeaderboardEntry] = []
    var participantAvatars: [AvatarView.Source] = []
    var overflowCount: Int = 0
    var warning: Warning? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    var showsTrophy: Bool = false

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            headerRow
            if !leaderboard.isEmpty {
                leaderboardList
            }
            if hasFooter {
                footerRow
            }
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .strokeBorder(AppColors.separator.opacity(0.5), lineWidth: 1)
        )
    }

    private var hasFooter: Bool {
        warning != nil || !participantAvatars.isEmpty || actionTitle != nil
    }

    // MARK: Header

    private var headerRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                statusRow
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(AppColors.primaryText)
                    .lineLimit(2)
            }
            Spacer(minLength: AppSpacing.md)
            if let rank {
                rankBadge(rank: rank)
            }
        }
    }

    private var statusRow: some View {
        HStack(spacing: AppSpacing.xs) {
            statusIcon
            Text(statusText)
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .tracking(0.8)
                .foregroundStyle(statusColor)
        }
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch status {
        case .active:
            Circle()
                .fill(statusColor)
                .frame(width: 7, height: 7)
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(statusColor)
        case .future:
            Image(systemName: "clock.fill")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(statusColor)
        }
    }

    private var statusText: String {
        switch status {
        case .active(let days):
            return "ACTIVE · \(days) \(days == 1 ? "DAY" : "DAYS") LEFT"
        case .completed:
            return "COMPLETED"
        case .future(let days):
            return "STARTS IN \(days) \(days == 1 ? "DAY" : "DAYS")"
        }
    }

    private var statusColor: Color {
        switch status {
        case .active, .completed: return AppColors.accent
        case .future: return AppColors.secondaryText
        }
    }

    private func rankBadge(rank: Int) -> some View {
        HStack(alignment: .center, spacing: AppSpacing.sm) {
            VStack(alignment: .trailing, spacing: 0) {
                Text("#\(rank)")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(rankTint)
                Text(rankSubtitle)
                    .font(AppTypography.caption2)
                    .foregroundStyle(AppColors.secondaryText)
            }
            if showsTrophy {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(rankTint)
                    .frame(width: 36, height: 36)
                    .background(Circle().fill(rankTint.opacity(0.18)))
            }
        }
    }

    private var rankSubtitle: String {
        if case .completed = status { return "Final" }
        return rankLabel
    }

    // MARK: Leaderboard

    private var leaderboardList: some View {
        VStack(spacing: AppSpacing.sm) {
            ForEach(leaderboard) { entry in
                leaderboardRow(entry)
            }
        }
    }

    private func leaderboardRow(_ entry: LeaderboardEntry) -> some View {
        HStack(spacing: AppSpacing.sm) {
            rankCircle(for: entry.rank)
            AvatarView(
                source: entry.avatar,
                size: 28,
                backgroundColor: AppColors.accent.opacity(0.2),
                foregroundColor: AppColors.accent
            )
            Text(entry.name)
                .font(AppTypography.subheadline)
                .fontWeight(entry.isCurrentUser ? .bold : .medium)
                .foregroundStyle(
                    entry.isCurrentUser ? AppColors.primaryText : AppColors.secondaryText
                )
                .lineLimit(1)
                .frame(width: 70, alignment: .leading)
            Spacer(minLength: 0)
            Text(entry.score.formatted())
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
                .monospacedDigit()
            progressBar(progress: entry.progress, tint: entry.barTint ?? rankTint)
                .frame(width: 80, height: 6)
        }
    }

    private func rankCircle(for rank: Int) -> some View {
        ZStack {
            Circle().fill(rankCircleColor(for: rank))
            Text("\(rank)")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(AppColors.primary)
        }
        .frame(width: 22, height: 22)
    }

    private func rankCircleColor(for rank: Int) -> Color {
        switch rank {
        case 1: return Color(red: 0.96, green: 0.78, blue: 0.30) // gold
        case 2: return Color(white: 0.70)                         // silver
        case 3: return Color(red: 0.85, green: 0.45, blue: 0.20)  // bronze
        default: return AppColors.secondaryText
        }
    }

    private func progressBar(progress: Double, tint: Color) -> some View {
        let clamped = max(0, min(1, progress))
        return GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.white.opacity(0.08))
                Capsule()
                    .fill(tint)
                    .frame(width: max(0, geo.size.width * clamped))
            }
        }
    }

    // MARK: Footer

    private var footerRow: some View {
        HStack(alignment: .center) {
            footerLeading
            Spacer(minLength: AppSpacing.md)
            if let actionTitle, let action {
                actionButton(title: actionTitle, action: action)
            }
        }
    }

    @ViewBuilder
    private var footerLeading: some View {
        if let warning {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: warning.icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(warning.text)
                    .font(AppTypography.footnote)
                    .fontWeight(.medium)
            }
            .foregroundStyle(warning.tint)
        } else if !participantAvatars.isEmpty {
            avatarStack
        } else {
            Color.clear.frame(height: 1)
        }
    }

    private var avatarStack: some View {
        HStack(spacing: -8) {
            ForEach(Array(participantAvatars.enumerated()), id: \.offset) { _, source in
                AvatarView(
                    source: source,
                    size: 26,
                    backgroundColor: AppColors.accent.opacity(0.2),
                    foregroundColor: AppColors.accent
                )
                .overlay(
                    Circle().stroke(AppColors.secondaryBackground, lineWidth: 2)
                )
            }
            if overflowCount > 0 {
                Text("+\(overflowCount)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColors.accent)
                    .padding(.leading, AppSpacing.sm)
            }
        }
    }

    private func actionButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(AppColors.onAccent)
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.sm)
                .background(Capsule().fill(rankTint))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("Challenge Card") {
    ScrollView {
        VStack(spacing: AppSpacing.lg) {
            ChallengeCard(
                title: "Morning Crushers",
                status: .active(daysRemaining: 3),
                rank: 1,
                leaderboard: [
                    .init(rank: 1, name: "You", avatar: .initials("YO"), score: 843, progress: 1.0, isCurrentUser: true),
                    .init(rank: 2, name: "Marcus", avatar: .initials("MA"), score: 791, progress: 0.92),
                    .init(rank: 3, name: "Jake", avatar: .initials("JA"), score: 650, progress: 0.78,
                          barTint: Color(red: 0.85, green: 0.45, blue: 0.20))
                ],
                participantAvatars: [.initials("PR"), .initials("AL"), .initials("TM")],
                overflowCount: 2,
                actionTitle: "Log Now",
                action: {}
            )

            ChallengeCard(
                title: "Office Challengers",
                status: .active(daysRemaining: 7),
                rank: 3,
                rankTint: Color(red: 0.96, green: 0.78, blue: 0.30),
                leaderboard: [
                    .init(rank: 1, name: "Priya", avatar: .initials("PR"), score: 1120, progress: 1.0),
                    .init(rank: 2, name: "Alex", avatar: .initials("AL"), score: 980, progress: 0.85),
                    .init(rank: 3, name: "You", avatar: .initials("YO"), score: 843, progress: 0.72,
                          isCurrentUser: true,
                          barTint: Color(red: 0.85, green: 0.45, blue: 0.20))
                ],
                warning: .init(icon: "exclamationmark.triangle.fill", text: "277 behind 2nd place"),
                actionTitle: "Catch Up",
                action: {}
            )

            ChallengeCard(
                title: "Weekend Warriors",
                status: .completed,
                rank: 1,
                showsTrophy: true
            )

            ChallengeCard(
                title: "January Kickoff",
                status: .future(daysUntilStart: 5),
                rank: nil
            )
        }
        .padding()
    }
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
