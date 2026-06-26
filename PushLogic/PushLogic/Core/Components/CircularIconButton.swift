//
//  CircularIconButton.swift
//  PushLogic
//
//  Reusable circular icon button used for header / chrome actions like
//  notifications and search. Optional badge dot for future use.
//

import SwiftUI

struct CircularIconButton: View {
    let systemImage: String
    var size: CGFloat = 44
    var iconColor: Color = AppColors.accent
    var backgroundColor: Color = AppColors.accent.opacity(0.15)
    var hasBadge: Bool = false
    var accessibilityLabel: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: size, height: size)

                Image(systemName: systemImage)
                    .font(.system(size: size * 0.4, weight: .semibold))
                    .foregroundStyle(iconColor)

                if hasBadge {
                    Circle()
                        .fill(AppColors.error)
                        .frame(width: 9, height: 9)
                        .overlay(
                            Circle()
                                .stroke(AppColors.background, lineWidth: 1.5)
                        )
                        .offset(x: size * 0.28, y: -size * 0.28)
                }
            }
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel ?? systemImage)
        .accessibilityAddTraits(.isButton)
    }
}
