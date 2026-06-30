//
//  GoalSelector.swift
//  PushLogic
//
//  Push-up goal control: stepper buttons flanking a large centered
//  value, a difficulty progress bar with Easy / Moderate / Beast
//  labels, and a row of quick-preset chips. Reusable — caller owns
//  the binding. No persistence.
//

import SwiftUI

struct GoalSelector: View {
    @Binding var value: Int

    var minValue: Int = 0
    var maxValue: Int = 5_000
    var step: Int = 25
    var difficultyCap: Int = 1_500
    var presets: [Int] = [100, 250, 500, 750, 1_000]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            valueCard
            presetsSection
        }
    }

    // MARK: Value card

    private var valueCard: some View {
        VStack(spacing: AppSpacing.lg) {
            HStack {
                stepperButton(.down)
                Spacer(minLength: 0)
                valueStack
                Spacer(minLength: 0)
                stepperButton(.up)
            }

            difficultyBar
            difficultyLabels
        }
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

    private var valueStack: some View {
        VStack(spacing: 0) {
            Text("\(value)")
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.accent)
                .contentTransition(.numericText(value: Double(value)))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text("PUSH-UPS")
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .tracking(1.6)
                .foregroundStyle(AppColors.secondaryText)
        }
    }

    private func stepperButton(_ direction: StepperDirection) -> some View {
        Button {
            adjust(direction)
        } label: {
            Image(systemName: direction == .up ? "plus" : "minus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.accent)
                .frame(width: 52, height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white.opacity(0.04))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(AppColors.separator.opacity(0.6), lineWidth: 1)
                )
        }
        .buttonStyle(SteppedPressStyle())
        .disabled(direction == .down ? value <= minValue : value >= maxValue)
        .accessibilityLabel(direction == .up ? "Increase goal" : "Decrease goal")
    }

    // MARK: Difficulty bar

    private var difficultyBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.08))
                Capsule()
                    .fill(AppGradients.brandHorizontal)
                    .frame(width: max(0, geo.size.width * progressFraction))
                    .animation(AppAnimation.progressRing, value: value)
            }
        }
        .frame(height: 6)
    }

    private var difficultyLabels: some View {
        HStack {
            Text("Easy")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Moderate")
                .frame(maxWidth: .infinity, alignment: .center)
            Text("Beast")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(AppTypography.caption)
        .foregroundStyle(AppColors.secondaryText)
    }

    private var progressFraction: Double {
        guard difficultyCap > 0 else { return 0 }
        return min(1, max(0, Double(value) / Double(difficultyCap)))
    }

    // MARK: Presets

    private var presetsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Quick Presets")
                .font(AppTypography.footnote)
                .foregroundStyle(AppColors.secondaryText)
            HStack(spacing: AppSpacing.sm) {
                ForEach(presets, id: \.self) { preset in
                    presetChip(preset)
                }
            }
        }
    }

    private func presetChip(_ preset: Int) -> some View {
        let isSelected = value == preset
        return Button {
            select(preset)
        } label: {
            Text(formatPreset(preset))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(isSelected ? AppColors.accent : AppColors.primaryText)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected
                              ? AppColors.accent.opacity(0.15)
                              : AppColors.secondaryBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(
                            isSelected ? AppColors.accent : AppColors.separator.opacity(0.5),
                            lineWidth: isSelected ? 1.5 : 1
                        )
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(preset) push-ups")
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
    }

    // MARK: Helpers

    private enum StepperDirection {
        case up, down
    }

    private func adjust(_ direction: StepperDirection) {
        let delta = direction == .up ? step : -step
        let newValue = max(minValue, min(maxValue, value + delta))
        withAnimation(AppAnimation.buttonSpring) {
            value = newValue
        }
    }

    private func select(_ preset: Int) {
        let clamped = max(minValue, min(maxValue, preset))
        withAnimation(AppAnimation.buttonSpring) {
            value = clamped
        }
    }

    private func formatPreset(_ value: Int) -> String {
        if value >= 1_000 && value % 1_000 == 0 {
            return "\(value / 1_000)K"
        }
        return "\(value)"
    }
}

// MARK: - Press style

private struct SteppedPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(AppAnimation.buttonSpring, value: configuration.isPressed)
    }
}

#Preview("Goal Selector") {
    @Previewable @State var value: Int = 500
    return GoalSelector(value: $value)
        .padding()
        .background(AppColors.background)
        .preferredColorScheme(.dark)
}
