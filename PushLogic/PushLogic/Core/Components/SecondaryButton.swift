//
//  SecondaryButton.swift
//  PushLogic
//
//  Medium-emphasis outlined button built on SecondaryButtonStyle.
//

import SwiftUI

struct SecondaryButton: View {
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
        .buttonStyle(.appSecondary)
    }
}
