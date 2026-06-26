//
//  AppCornerRadius.swift
//  PushLogic
//
//  Centralized corner radii. Consistent rounding per Apple's HIG.
//

import CoreGraphics

enum AppCornerRadius {
    /// 4pt — subtle rounding for chips and small badges.
    static let xs: CGFloat = 4

    /// 8pt — controls and inline elements.
    static let sm: CGFloat = 8

    /// 12pt — default for cards and surfaces.
    static let md: CGFloat = 12

    /// 16pt — prominent cards and primary buttons.
    static let lg: CGFloat = 16

    /// 24pt — large hero surfaces.
    static let xl: CGFloat = 24

    /// Fully rounded — pills, capsules, avatars.
    static let pill: CGFloat = 999
}
