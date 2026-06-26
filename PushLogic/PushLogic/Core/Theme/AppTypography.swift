//
//  AppTypography.swift
//  PushLogic
//
//  Centralized typography. Built on SF Pro via SwiftUI's text styles so
//  Dynamic Type works automatically per Apple's HIG. Numeric displays
//  use a rounded design for legibility at large sizes.
//

import SwiftUI

enum AppTypography {
    // MARK: Display / Hero

    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let title2 = Font.title2.weight(.semibold)
    static let title3 = Font.title3.weight(.semibold)

    // MARK: Body

    static let headline = Font.headline
    static let body = Font.body
    static let bodyEmphasized = Font.body.weight(.semibold)
    static let callout = Font.callout
    static let subheadline = Font.subheadline

    // MARK: Supporting

    static let footnote = Font.footnote
    static let caption = Font.caption
    static let caption2 = Font.caption2

    // MARK: Numeric displays (rounded design, fixed sizes for counters/stats)

    /// Hero counter — e.g. live push-up count.
    static let counterDisplay = Font.system(size: 96, weight: .bold, design: .rounded)

    /// Large stat value — e.g. dashboard totals.
    static let statLarge = Font.system(size: 56, weight: .semibold, design: .rounded)

    /// Medium stat value — e.g. cards.
    static let statMedium = Font.system(size: 32, weight: .semibold, design: .rounded)

    /// Small stat value — e.g. inline metrics.
    static let statSmall = Font.system(size: 20, weight: .medium, design: .rounded)
}
