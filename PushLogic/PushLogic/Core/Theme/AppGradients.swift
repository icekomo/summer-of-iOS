//
//  AppGradients.swift
//  PushLogic
//
//  Centralized gradients built from the brand palette.
//

import SwiftUI

enum AppGradients {
    /// Primary brand gradient — deep navy → mint, diagonal.
    static let brand = LinearGradient(
        colors: [AppColors.primary, AppColors.accent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    /// Horizontal brand gradient — useful for progress fills.
    static let brandHorizontal = LinearGradient(
        colors: [AppColors.primary, AppColors.accent],
        startPoint: .leading,
        endPoint: .trailing
    )

    /// Vertical brand gradient — useful for backgrounds.
    static let brandVertical = LinearGradient(
        colors: [AppColors.primary, AppColors.accent],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Subtle surface gradient that adapts to light/dark.
    static let surface = LinearGradient(
        colors: [AppColors.background, AppColors.secondaryBackground],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Interpolated progress gradient. Returns a gradient that visually
    /// reflects completion `percentage` (0.0 ... 1.0) by shifting the
    /// stops along the brand palette.
    static func progress(percentage: Double) -> LinearGradient {
        let clamped = max(0, min(1, percentage))
        return LinearGradient(
            stops: [
                .init(color: AppColors.primary, location: 0),
                .init(color: AppColors.accent, location: clamped)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
