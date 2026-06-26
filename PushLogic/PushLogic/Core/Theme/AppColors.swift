//
//  AppColors.swift
//  PushLogic
//
//  Centralized color palette. Brand colors are fixed; surface and
//  content colors defer to system semantic colors so light/dark mode
//  adapts automatically per Apple's HIG.
//

import SwiftUI

enum AppColors {
    // MARK: Brand

    /// Deep navy — primary brand color (#0D1B2A).
    static let primary = Color.appHex(0x0D1B2A)

    /// Bright mint — accent / call-to-action color (#66F7B5).
    static let accent = Color.appHex(0x66F7B5)

    // MARK: Foreground on brand

    /// Foreground color to use on top of `primary`.
    static let onPrimary = Color.white

    /// Foreground color to use on top of `accent`.
    static let onAccent = Color.appHex(0x0D1B2A)

    // MARK: Surfaces (adapts to light/dark)

    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    static let groupedBackground = Color(.systemGroupedBackground)

    // MARK: Content (adapts to light/dark)

    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)
    static let placeholderText = Color(.placeholderText)

    // MARK: Separators / borders

    static let separator = Color(.separator)
    static let opaqueSeparator = Color(.opaqueSeparator)

    // MARK: Semantic

    static let success = Color(.systemGreen)
    static let warning = Color(.systemOrange)
    static let error = Color(.systemRed)
    static let info = Color(.systemBlue)
}

private extension Color {
    /// File-private hex initializer used only by `AppColors`.
    static func appHex(_ value: UInt32) -> Color {
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        return Color(.sRGB, red: r, green: g, blue: b, opacity: 1)
    }
}
