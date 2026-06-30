//
//  ActiveChallengesSection.swift
//  PushLogic
//
//  Dashboard "Push Groups" section — DashboardSectionHeader on top,
//  vertical stack of ChallengeCards below (or an empty state when the
//  user has no active challenges). Scrolls naturally inside the
//  dashboard's parent ScrollView.
//

import SwiftUI

struct ActiveChallengesSection: View {
    let challenges: [Challenge]
    var onSeeAll: (() -> Void)? = {}
    var onLogNow: (Challenge) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            DashboardSectionHeader(title: "Push Groups", action: onSeeAll)

            if challenges.isEmpty {
                emptyState
            } else {
                VStack(spacing: AppSpacing.md) {
                    ForEach(challenges, id: \.id) { challenge in
                        card(for: challenge)
                    }
                }
            }
        }
    }

    // MARK: Card

    private func card(for challenge: Challenge) -> some View {
        let status: ChallengeCard.Status = challenge.isCompleted
            ? .completed
            : .active(daysRemaining: challenge.daysRemaining)

        return ChallengeCard(
            title: challenge.title,
            status: status,
            rank: nil,
            actionTitle: challenge.isCompleted ? nil : "Log Now",
            action: challenge.isCompleted ? nil : { onLogNow(challenge) },
            showsTrophy: challenge.isCompleted
        )
    }

    // MARK: Empty state

    private var emptyState: some View {
        EmptyStateView(
            title: "No Active Challenges",
            message: "Tap the + button below to start your first challenge.",
            systemImage: "trophy"
        )
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .strokeBorder(AppColors.separator.opacity(0.5), lineWidth: 1)
        )
    }
}
