//
//  AppSpacing.swift
//  PushLogic
//
//  Centralized spacing scale built on an 8pt grid per Apple's HIG.
//

import CoreGraphics

enum AppSpacing {
    /// 2pt — hairline gap.
    static let xxs: CGFloat = 2

    /// 4pt — tight grouping.
    static let xs: CGFloat = 4

    /// 8pt — standard inline spacing.
    static let sm: CGFloat = 8

    /// 12pt — comfortable inline spacing.
    static let md: CGFloat = 12

    /// 16pt — default content padding.
    static let lg: CGFloat = 16

    /// 24pt — section spacing.
    static let xl: CGFloat = 24

    /// 32pt — major section breaks.
    static let xxl: CGFloat = 32

    /// 48pt — hero spacing.
    static let xxxl: CGFloat = 48

    /// 64pt — full-screen vertical rhythm.
    static let huge: CGFloat = 64

    // MARK: Layout constants

    /// Minimum tap-target size per HIG (44pt).
    static let minTapTarget: CGFloat = 44

    /// Standard horizontal screen padding.
    static let screenHorizontal: CGFloat = 16

    /// Standard vertical screen padding.
    static let screenVertical: CGFloat = 16
}
