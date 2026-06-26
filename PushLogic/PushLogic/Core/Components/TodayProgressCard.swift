//
//  TodayProgressCard.swift
//  PushLogic
//
//  Hero card summarizing today's push-up activity. Receives values via
//  initializer — knows nothing about persistence.
//

import SwiftUI

struct TodayProgressCard: View {
    let current: Int
    let goal: Int
    let streakDays: Int
    var subtitle: String = "Push-ups logged today"

    @State private var animatedProgress: Double = 0

    // MARK: Computed

    private var progress: Double {
        guard goal > 0 else { return 0 }
        return min(1, max(0, Double(current) / Double(goal)))
    }

    private var percentage: Int {
        Int((progress * 100).rounded())
    }

    private var preciseGoalText: String {
        String(format: "%.1f%% to goal", progress * 100)
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            todayLabel
            mainRow
            badgesRow
            progressBar
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: AppColors.accent.opacity(0.18), radius: 24, x: 0, y: 10)
        .onAppear {
            withAnimation(AppAnimation.progressRing.delay(0.15)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(AppAnimation.progressRing) {
                animatedProgress = newValue
            }
        }
    }

    // MARK: Subviews

    private var todayLabel: some View {
        HStack(spacing: AppSpacing.xs) {
            Circle()
                .fill(AppColors.accent)
                .frame(width: 7, height: 7)
            Text("TODAY")
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .tracking(1.4)
                .foregroundStyle(AppColors.accent)
        }
    }

    private var mainRow: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xs) {
                    Text("\(current)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: Double(current)))
                    Text("/ \(goal)")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppColors.accent)
                }
                Text(subtitle)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(Color.white.opacity(0.6))
            }
            Spacer(minLength: 0)
            ring
        }
    }

    private var ring: some View {
        ZStack {
            ProgressRing(
                progress: animatedProgress,
                lineWidth: 8,
                foreground: AppGradients.brandHorizontal,
                background: Color.white.opacity(0.12)
            )
            .frame(width: 84, height: 84)

            VStack(spacing: 0) {
                Text("\(percentage)%")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(value: Double(percentage)))
                Text("done")
                    .font(AppTypography.caption2)
                    .foregroundStyle(AppColors.accent)
            }
        }
    }

    private var badgesRow: some View {
        HStack(spacing: AppSpacing.sm) {
            goalBadge
            streakBadge
            Spacer(minLength: 0)
        }
    }

    private var goalBadge: some View {
        Text(preciseGoalText)
            .font(AppTypography.footnote)
            .fontWeight(.medium)
            .foregroundStyle(AppColors.accent)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(Capsule().fill(AppColors.accent.opacity(0.18)))
    }

    private var streakBadge: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: .semibold))
            Text("\(streakDays) Day Streak")
                .font(AppTypography.footnote)
                .fontWeight(.medium)
        }
        .foregroundStyle(Self.streakAmber)
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(Capsule().fill(Self.streakAmber.opacity(0.18)))
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                Capsule()
                    .fill(AppGradients.brandHorizontal)
                    .frame(width: max(0, geo.size.width * animatedProgress))
            }
        }
        .frame(height: 8)
    }

    // MARK: Background

    private var cardBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.20, blue: 0.18),
                    Color(red: 0.03, green: 0.09, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            AppColors.accent.opacity(0.35),
                            AppColors.accent.opacity(0.04)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        }
    }

    // MARK: Palette

    private static let streakAmber = Color(red: 1.0, green: 0.65, blue: 0.25)
}

#Preview("Dark") {
    TodayProgressCard(current: 127, goal: 200, streakDays: 5)
        .padding()
        .background(AppColors.background)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    TodayProgressCard(current: 127, goal: 200, streakDays: 5)
        .padding()
        .background(AppColors.background)
        .preferredColorScheme(.light)
}
