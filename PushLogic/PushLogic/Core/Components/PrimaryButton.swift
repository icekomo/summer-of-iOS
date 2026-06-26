//
//  PrimaryButton.swift
//  PushLogic
//
//  High-emphasis call-to-action button built on PrimaryButtonStyle.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    var systemImage: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
        }
        .buttonStyle(.appPrimary)
    }
}
