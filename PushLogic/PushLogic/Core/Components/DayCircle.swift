//
//  DayCircle.swift
//  PushLogic
//
//  Single day-of-week indicator used by the Weekly Streak row.
//  Three states: completed (mint fill + checkmark), current (translucent
//  mint with letter), future (dim track with letter). Springs in on
//  appear with an optional stagger delay.
//

import SwiftUI

struct DayCircle: View {
    enum DayState {
        case completed
        case current
        case future
    }

    let letter: String
    let state: DayState
    var animationDelay: Double = 0

    @State private var hasAppeared: Bool = false

    var body: some View {
        VStack(spacing: AppSpacing.xs) {
            box
            label
        }
    }

    // MARK: Box

    private var box: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(boxBackground)
            symbol
        }
        .frame(width: 38, height: 38)
        .scaleEffect(hasAppeared ? 1.0 : 0.6)
        .opacity(hasAppeared ? 1.0 : 0.0)
        .shadow(
            color: state == .completed ? AppColors.accent.opacity(0.35) : .clear,
            radius: 8, x: 0, y: 2
        )
        .onAppear {
            withAnimation(AppAnimation.cardLift.delay(animationDelay)) {
                hasAppeared = true
            }
        }
    }

    @ViewBuilder
    private var symbol: some View {
        switch state {
        case .completed:
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppColors.primary)
                .transition(.scale.combined(with: .opacity))
        case .current:
            Text(letter)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppColors.accent)
        case .future:
            Text(letter)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.3))
        }
    }

    private var boxBackground: Color {
        switch state {
        case .completed: return AppColors.accent
        case .current: return AppColors.accent.opacity(0.15)
        case .future: return Color.white.opacity(0.05)
        }
    }

    // MARK: Label

    private var label: some View {
        Text(letter)
            .font(.system(size: 12, weight: state == .current ? .bold : .medium))
            .foregroundStyle(labelColor)
    }

    private var labelColor: Color {
        switch state {
        case .completed: return AppColors.secondaryText
        case .current: return AppColors.accent
        case .future: return Color.white.opacity(0.35)
        }
    }
}
