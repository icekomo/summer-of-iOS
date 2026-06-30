//
//  CreateChallengeView.swift
//  PushLogic
//
//  Foundation layout for the Create Challenge flow. Top chrome
//  (navigation header + progress indicator) is pinned above a scrolling
//  body; the bottom action bar is pinned below. Each section is an
//  empty labeled placeholder until its real content is built.
//

import SwiftUI

struct CreateChallengeView: View {
    var onBack: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            topChrome
            scrollingContent
            bottomActionBarPlaceholder
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
                .padding(.bottom, AppSpacing.sm)
        }
        .background(AppColors.background.ignoresSafeArea())
    }

    // MARK: Top chrome (pinned)

    private var topChrome: some View {
        VStack(spacing: AppSpacing.md) {
            WizardHeader(
                eyebrow: "PUSH FITNESS",
                title: "New Challenge",
                currentStep: 1,
                totalSteps: 2,
                onBack: onBack
            )
            WizardProgress(steps: ["Setup", "Invite"], currentStep: 1)
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.top, AppSpacing.md)
        .padding(.bottom, AppSpacing.sm)
    }

    // MARK: Scrolling body

    private var scrollingContent: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                challengeNamePlaceholder
                goalSelectorPlaceholder
                durationPlaceholder
                privacyPlaceholder
                extraSettingsPlaceholder
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.md)
            .padding(.bottom, AppSpacing.xl)
        }
        .scrollIndicators(.hidden)
    }

    // MARK: Section placeholders

    private var challengeNamePlaceholder: some View {
        sectionPlaceholder(title: "Challenge Name", height: 180)
    }

    private var goalSelectorPlaceholder: some View {
        sectionPlaceholder(title: "Goal Selector", height: 260)
    }

    private var durationPlaceholder: some View {
        sectionPlaceholder(title: "Duration", height: 260)
    }

    private var privacyPlaceholder: some View {
        sectionPlaceholder(title: "Privacy", height: 240)
    }

    private var extraSettingsPlaceholder: some View {
        sectionPlaceholder(title: "Extra Settings", height: 220)
    }

    private var bottomActionBarPlaceholder: some View {
        sectionPlaceholder(title: "Bottom Action Bar", height: 96)
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

#Preview("Create Challenge — Dark") {
    CreateChallengeView()
        .preferredColorScheme(.dark)
}

#Preview("Create Challenge — Light") {
    CreateChallengeView()
        .preferredColorScheme(.light)
}
