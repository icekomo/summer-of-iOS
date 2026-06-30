//
//  WeeklyStreakCard.swift
//  PushLogic
//
//  Card showing seven DayCircle indicators for the current week.
//  Pure presentation — receives the day model array from the caller.
//

import SwiftUI

struct WeeklyStreakCard: View {
    struct Day: Identifiable {
        let id = UUID()
        let letter: String
        let state: DayCircle.DayState
    }

    let days: [Day]
    var title: String = "Weekly Streak"
    var subtitle: String = "Mon–Sun"

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            header
            row
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

    private var header: some View {
        HStack {
            Text(title)
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.primaryText)
            Spacer()
            Text(subtitle)
                .font(AppTypography.footnote)
                .foregroundStyle(AppColors.accent)
        }
    }

    private var row: some View {
        HStack(spacing: AppSpacing.xs) {
            ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                DayCircle(
                    letter: day.letter,
                    state: day.state,
                    animationDelay: Double(index) * 0.05
                )
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview("Dark") {
    WeeklyStreakCard(days: [
        .init(letter: "M", state: .completed),
        .init(letter: "T", state: .completed),
        .init(letter: "W", state: .completed),
        .init(letter: "T", state: .completed),
        .init(letter: "F", state: .current),
        .init(letter: "S", state: .future),
        .init(letter: "S", state: .future)
    ])
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
