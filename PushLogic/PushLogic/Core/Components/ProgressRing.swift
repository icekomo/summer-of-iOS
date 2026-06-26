//
//  ProgressRing.swift
//  PushLogic
//
//  Circular progress indicator. Generic over any ShapeStyle so callers
//  can supply solid colors, gradients, or materials.
//

import SwiftUI

struct ProgressRing<Foreground: ShapeStyle, Background: ShapeStyle>: View {
    let progress: Double
    var lineWidth: CGFloat = 12
    let foreground: Foreground
    let background: Background

    var body: some View {
        let clamped = max(0, min(1, progress))
        ZStack {
            Circle()
                .stroke(background, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(
                    foreground,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(AppAnimation.progressRing, value: clamped)
        }
    }
}

extension ProgressRing where Foreground == LinearGradient, Background == Color {
    /// Convenience initializer using the brand gradient on a subtle track.
    init(progress: Double, lineWidth: CGFloat = 12) {
        self.progress = progress
        self.lineWidth = lineWidth
        self.foreground = AppGradients.brandHorizontal
        self.background = AppColors.tertiaryBackground
    }
}
