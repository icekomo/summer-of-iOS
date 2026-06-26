//
//  LoadingView.swift
//  PushLogic
//
//  Generic loading indicator with an optional message.
//

import SwiftUI

struct LoadingView: View {
    var message: String? = nil

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .controlSize(.large)
                .tint(AppColors.accent)
            if let message {
                Text(message)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
