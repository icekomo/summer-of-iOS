//
//  DashboardView.swift
//  PushLogic
//
//  Home tab layout scaffolding. Defines the section order and spacing
//  using the design system; each section is an empty labeled
//  placeholder until its real content is built.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                DashboardHeader()
                todayProgressPlaceholder
                statisticsPlaceholder
                weeklyStreakPlaceholder
                activityChartPlaceholder
                activeChallengesPlaceholder
                friendActivityPlaceholder
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.huge)
        }
        .scrollIndicators(.hidden)
        .background(AppColors.background.ignoresSafeArea())
    }

    // MARK: Section placeholders

    private var todayProgressPlaceholder: some View {
        sectionPlaceholder(title: "Today's Progress", height: 180)
    }

    private var statisticsPlaceholder: some View {
        sectionPlaceholder(title: "Statistics", height: 110)
    }

    private var weeklyStreakPlaceholder: some View {
        sectionPlaceholder(title: "Weekly Streak", height: 130)
    }

    private var activityChartPlaceholder: some View {
        sectionPlaceholder(title: "Activity Chart", height: 220)
    }

    private var activeChallengesPlaceholder: some View {
        sectionPlaceholder(title: "Active Challenges", height: 260)
    }

    private var friendActivityPlaceholder: some View {
        sectionPlaceholder(title: "Friend Activity", height: 200)
    }

    // MARK: Builder

    private func sectionPlaceholder(title: String, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
            .fill(AppColors.secondaryBackground)
            .frame(height: height)
            .overlay {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.secondaryText)
            }
    }
}

#Preview("Dark") {
    DashboardView()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    DashboardView()
        .preferredColorScheme(.light)
}
