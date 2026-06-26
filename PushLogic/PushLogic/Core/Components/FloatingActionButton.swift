//
//  FloatingActionButton.swift
//  PushLogic
//
//  Center button inside BottomNavigationBar that launches the Create
//  Challenge flow. Renders a dashed mint circle with a "+" — visually
//  elevated, with a subtle accent glow and spring press feedback.
//

import SwiftUI

struct FloatingActionButton: View {
    let label: String
    let systemImage: String
    let action: () -> Void

    @State private var isPressed: Bool = false

    init(
        label: String = "New",
        systemImage: String = "plus",
        action: @escaping () -> Void
    ) {
        self.label = label
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            VStack(spacing: AppSpacing.xs) {
                circle
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(AppColors.accent)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
            .contentShape(Rectangle())
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .animation(AppAnimation.buttonSpring, value: isPressed)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityAddTraits(.isButton)
        .simultaneousGesture(pressGesture)
    }

    private var circle: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    AppColors.accent,
                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                )
                .frame(width: 44, height: 44)
                .shadow(color: AppColors.accent.opacity(0.45), radius: 8, x: 0, y: 0)

            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColors.accent)
        }
        .frame(height: 44)
    }

    private var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                if !isPressed { isPressed = true }
            }
            .onEnded { _ in
                isPressed = false
            }
    }
}
