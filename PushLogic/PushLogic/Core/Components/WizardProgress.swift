//
//  WizardProgress.swift
//  PushLogic
//
//  Reusable progress indicator for multi-step wizards. Renders a thin
//  animated bar above a row of step labels. Works for any number of
//  steps; the bar springs to the new fraction when `currentStep`
//  changes.
//

import SwiftUI

struct WizardProgress: View {
    let steps: [String]
    let currentStep: Int

    @State private var animatedProgress: Double = 0

    // MARK: Computed

    private var progress: Double {
        guard !steps.isEmpty else { return 0 }
        return min(1, max(0, Double(currentStep) / Double(steps.count)))
    }

    // MARK: Body

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            progressBar
            labelRow
        }
        .onAppear {
            withAnimation(AppAnimation.standard) {
                animatedProgress = progress
            }
        }
        .onChange(of: currentStep) { _, _ in
            withAnimation(AppAnimation.progressRing) {
                animatedProgress = progress
            }
        }
    }

    // MARK: Subviews

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                Capsule()
                    .fill(AppColors.accent)
                    .frame(width: max(0, geo.size.width * animatedProgress))
                    .shadow(color: AppColors.accent.opacity(0.4), radius: 4, x: 0, y: 0)
            }
        }
        .frame(height: 3)
        .accessibilityLabel("Step \(currentStep) of \(steps.count)")
    }

    private var labelRow: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(steps.indices, id: \.self) { index in
                Text("Step \(index + 1) — \(steps[index])")
                    .font(AppTypography.caption)
                    .fontWeight(index + 1 == currentStep ? .semibold : .medium)
                    .foregroundStyle(color(for: index))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: alignment(for: index))
                    .animation(AppAnimation.standard, value: currentStep)
            }
        }
    }

    // MARK: Helpers

    private func color(for index: Int) -> Color {
        index + 1 == currentStep ? AppColors.accent : AppColors.secondaryText
    }

    private func alignment(for index: Int) -> Alignment {
        if index == 0 { return .leading }
        if index == steps.count - 1 { return .trailing }
        return .center
    }
}

#Preview("Wizard Progress — Dark") {
    VStack(spacing: AppSpacing.xl) {
        WizardProgress(steps: ["Setup", "Invite"], currentStep: 1)
        WizardProgress(steps: ["Setup", "Invite"], currentStep: 2)
        WizardProgress(steps: ["Setup", "Goal", "Invite", "Review"], currentStep: 2)
    }
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
