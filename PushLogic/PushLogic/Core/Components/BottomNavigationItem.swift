//
//  BottomNavigationItem.swift
//  PushLogic
//
//  A single slot in the BottomNavigationBar — icon, label, optional
//  badge, with selected / unselected presentation states.
//

import SwiftUI

struct BottomNavigationItem: View {
    let destination: NavigationDestination
    let isSelected: Bool
    var badge: Int? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                iconContainer
                Text(destination.title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                    .foregroundStyle(labelColor)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(destination.title)
        .accessibilityAddTraits(isSelected ? [.isSelected, .isButton] : .isButton)
        .animation(AppAnimation.buttonSpring, value: isSelected)
    }

    private var iconContainer: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: AppCornerRadius.md, style: .continuous)
                    .fill(Self.selectedBackground)
                    .frame(width: 56, height: 40)
                    .transition(.scale.combined(with: .opacity))
            }

            Image(systemName: destination.systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(iconColor)
                .scaleEffect(isSelected ? 1.08 : 1.0)

            if let badge {
                badgeView(count: badge)
                    .offset(x: 14, y: -12)
            }
        }
        .frame(height: 40)
    }

    private func badgeView(count: Int) -> some View {
        Text(count > 9 ? "9+" : "\(count)")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(Color.white)
            .padding(.horizontal, 5)
            .padding(.vertical, 2)
            .background(Capsule().fill(AppColors.error))
    }

    private var iconColor: Color {
        isSelected ? AppColors.accent : Self.inactive
    }

    private var labelColor: Color {
        isSelected ? AppColors.accent : Self.inactive
    }

    // MARK: Palette

    /// Translucent mint over the dark navy bar reads as a deep green tile.
    private static let selectedBackground = AppColors.accent.opacity(0.15)

    /// Slate-blue gray used for unselected icons + labels against the navy bar.
    private static let inactive = Color(red: 0.45, green: 0.52, blue: 0.58)
}
