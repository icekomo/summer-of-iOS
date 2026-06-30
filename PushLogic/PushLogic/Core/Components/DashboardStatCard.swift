//
//  DashboardStatCard.swift
//  PushLogic
//
//  Reusable single-stat tile used in the dashboard's three-column
//  statistics row. Pure presentation — receives icon, value, and title.
//

import SwiftUI

struct DashboardStatCard: View {
    let systemImage: String
    let iconTint: Color
    let iconBackground: Color
    let value: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            iconBubble
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(AppTypography.footnote)
                .foregroundStyle(AppColors.secondaryText)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .strokeBorder(AppColors.separator.opacity(0.5), lineWidth: 1)
        )
    }

    private var iconBubble: some View {
        Image(systemName: systemImage)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(iconTint)
            .frame(width: 40, height: 40)
            .background(Circle().fill(iconBackground))
    }
}

#Preview("Dark") {
    HStack(spacing: AppSpacing.md) {
        DashboardStatCard(
            systemImage: "flame.fill",
            iconTint: AppColors.primary,
            iconBackground: AppColors.accent,
            value: "5",
            title: "Day Streak"
        )
        DashboardStatCard(
            systemImage: "trophy.fill",
            iconTint: Color(red: 0.96, green: 0.78, blue: 0.30),
            iconBackground: Color(red: 0.96, green: 0.78, blue: 0.30).opacity(0.18),
            value: "213",
            title: "Best Day"
        )
        DashboardStatCard(
            systemImage: "chart.line.uptrend.xyaxis",
            iconTint: AppColors.accent,
            iconBackground: AppColors.accent.opacity(0.18),
            value: "843",
            title: "This Week"
        )
    }
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
