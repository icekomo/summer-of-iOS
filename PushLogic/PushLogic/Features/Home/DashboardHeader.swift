//
//  DashboardHeader.swift
//  PushLogic
//
//  Header row for DashboardView — small uppercase eyebrow, large
//  "Dashboard" title, and the notification + profile actions.
//

import SwiftUI

struct DashboardHeader: View {
    var notificationAction: () -> Void = {}
    var profileAction: () -> Void = {}
    var hasUnreadNotifications: Bool = true

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            titleStack
            Spacer(minLength: AppSpacing.md)
            actionStack
        }
    }

    private var titleStack: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            Text("PUSH LOGIC")
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .tracking(1.6)
                .foregroundStyle(AppColors.accent)

            Text("Dashboard")
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.primaryText)
        }
    }

    private var actionStack: some View {
        HStack(spacing: AppSpacing.sm) {
            CircularIconButton(
                systemImage: "bell.fill",
                hasBadge: hasUnreadNotifications,
                accessibilityLabel: "Notifications",
                action: notificationAction
            )

            Button(action: profileAction) {
                AvatarView(
                    source: .systemImage("person.fill"),
                    size: 44,
                    backgroundColor: AppColors.accent.opacity(0.2),
                    foregroundColor: AppColors.accent
                )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Profile")
            .accessibilityAddTraits(.isButton)
        }
    }
}

#Preview("Dark") {
    DashboardHeader()
        .padding()
        .background(AppColors.background)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    DashboardHeader()
        .padding()
        .background(AppColors.background)
        .preferredColorScheme(.light)
}
