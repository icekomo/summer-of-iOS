//
//  WizardHeader.swift
//  PushLogic
//
//  Reusable header for multi-step wizard flows. Renders a back button
//  on the left, a centered eyebrow + title, and a step indicator on
//  the right. No navigation logic — caller supplies `onBack`.
//

import SwiftUI

struct WizardHeader: View {
    let eyebrow: String
    let title: String
    let currentStep: Int
    let totalSteps: Int
    var onBack: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            backButton
                .frame(width: 50)

            titleStack
                .frame(maxWidth: .infinity)

            stepIndicator
                .frame(width: 50, alignment: .trailing)
        }
    }

    // MARK: Subviews

    private var backButton: some View {
        CircularIconButton(
            systemImage: "chevron.left",
            accessibilityLabel: "Back",
            action: onBack
        )
    }

    private var titleStack: some View {
        VStack(spacing: AppSpacing.xxs) {
            Text(eyebrow)
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .tracking(1.6)
                .foregroundStyle(AppColors.accent)

            Text(title)
                .font(AppTypography.title)
                .foregroundStyle(AppColors.primaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }

    private var stepIndicator: some View {
        Text("\(currentStep) / \(totalSteps)")
            .font(AppTypography.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(AppColors.accent)
            .monospacedDigit()
            .accessibilityLabel("Step \(currentStep) of \(totalSteps)")
    }
}

#Preview("Wizard Header — Dark") {
    VStack(spacing: AppSpacing.xl) {
        WizardHeader(
            eyebrow: "PUSH FITNESS",
            title: "New Challenge",
            currentStep: 1,
            totalSteps: 2,
            onBack: {}
        )
        WizardHeader(
            eyebrow: "PUSH FITNESS",
            title: "Invite Friends",
            currentStep: 2,
            totalSteps: 2,
            onBack: {}
        )
    }
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}

#Preview("Wizard Header — Light") {
    WizardHeader(
        eyebrow: "PUSH FITNESS",
        title: "New Challenge",
        currentStep: 1,
        totalSteps: 2,
        onBack: {}
    )
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.light)
}
