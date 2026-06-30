//
//  FriendActivitySection.swift
//  PushLogic
//
//  Dashboard "Friend Activity" section — DashboardSectionHeader on top,
//  vertical stack of FriendActivityCards below. Scrolls naturally inside
//  the dashboard's parent ScrollView. Mock data only.
//

import SwiftUI

struct FriendActivitySection: View {
    var onSeeAll: (() -> Void)? = {}
    var onJoin: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            DashboardSectionHeader(title: "Friend Activity", action: onSeeAll)

            VStack(spacing: AppSpacing.sm) {
                FriendActivityCard(
                    name: "Marcus",
                    message: "logged 50 push-ups",
                    timestamp: "2 min ago",
                    context: "Morning Crushers",
                    avatar: .initials("MA"),
                    kind: .joined
                )

                FriendActivityCard(
                    name: "Priya",
                    message: "hit a new PB! 137 reps",
                    timestamp: "14 min ago",
                    context: "Office Challengers",
                    avatar: .initials("PR"),
                    kind: .newPersonalBest
                )

                FriendActivityCard(
                    name: "Jordan",
                    message: "completed the 30-day challenge",
                    timestamp: "45 min ago",
                    avatar: .initials("JO"),
                    kind: .completed
                )

                FriendActivityCard(
                    name: "Tom",
                    message: "started a 7-day challenge",
                    timestamp: "1 hr ago",
                    context: "Join now",
                    avatar: .initials("TO"),
                    kind: .challengeInvite,
                    actionTitle: "Join",
                    onAction: onJoin
                )
            }
        }
    }
}

#Preview("Friend Activity Section") {
    ScrollView {
        FriendActivitySection()
            .padding()
    }
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
