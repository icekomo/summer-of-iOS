//
//  ButtonStyles.swift
//  PushLogic
//
//  Reusable button styles built from the design system. Tap targets
//  meet HIG's 44pt minimum and press feedback is subtle.
//

import SwiftUI

// MARK: - Primary

/// High-emphasis call-to-action. Mint background, navy label.
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyEmphasized)
            .foregroundStyle(AppColors.onAccent)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                    .fill(AppColors.accent)
            )
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(AppAnimation.buttonSpring, value: configuration.isPressed)
    }
}

// MARK: - Secondary

/// Medium-emphasis. Outlined in primary navy.
struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyEmphasized)
            .foregroundStyle(AppColors.primaryText)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                    .stroke(AppColors.primaryText.opacity(0.25), lineWidth: 1.5)
            )
            .opacity(isEnabled ? (configuration.isPressed ? 0.7 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(AppAnimation.buttonSpring, value: configuration.isPressed)
    }
}

// MARK: - Tertiary

/// Low-emphasis. Text-only with accent color.
struct TertiaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyEmphasized)
            .foregroundStyle(AppColors.primary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .frame(minHeight: AppSpacing.minTapTarget)
            .contentShape(Rectangle())
            .opacity(isEnabled ? (configuration.isPressed ? 0.6 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(AppAnimation.buttonSpring, value: configuration.isPressed)
    }
}

// MARK: - Destructive

/// High-emphasis destructive action. System red background.
struct DestructiveButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.bodyEmphasized)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, minHeight: AppSpacing.minTapTarget)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                    .fill(AppColors.error)
            )
            .opacity(isEnabled ? (configuration.isPressed ? 0.85 : 1) : 0.4)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(AppAnimation.buttonSpring, value: configuration.isPressed)
    }
}

// MARK: - Convenience

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var appPrimary: PrimaryButtonStyle { .init() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var appSecondary: SecondaryButtonStyle { .init() }
}

extension ButtonStyle where Self == TertiaryButtonStyle {
    static var appTertiary: TertiaryButtonStyle { .init() }
}

extension ButtonStyle where Self == DestructiveButtonStyle {
    static var appDestructive: DestructiveButtonStyle { .init() }
}
