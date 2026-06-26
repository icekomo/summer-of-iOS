//
//  GradientService.swift
//  PushLogic
//
//  Calculates progress-driven gradients and interpolated colors from the
//  brand palette (primary navy → accent mint).
//

import SwiftUI

final class GradientService {
    /// Linear gradient whose accent stop slides with completion `percentage`
    /// (0...1), giving a sense that color "fills in" as progress grows.
    func gradient(for percentage: Double) -> LinearGradient {
        let clamped = clamp(percentage)
        return LinearGradient(
            stops: [
                .init(color: AppColors.primary, location: 0),
                .init(color: AppColors.accent, location: clamped)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    /// Single color interpolated along the brand palette at `percentage` (0...1).
    func interpolatedColor(for percentage: Double) -> Color {
        let clamped = clamp(percentage)
        let from = UIColor(AppColors.primary).pl_components
        let to = UIColor(AppColors.accent).pl_components
        return Color(
            .sRGB,
            red: lerp(from.r, to.r, clamped),
            green: lerp(from.g, to.g, clamped),
            blue: lerp(from.b, to.b, clamped),
            opacity: lerp(from.a, to.a, clamped)
        )
    }

    private func clamp(_ value: Double) -> Double {
        max(0, min(1, value))
    }

    private func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + (b - a) * t
    }
}

private extension UIColor {
    var pl_components: (r: Double, g: Double, b: Double, a: Double) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}
