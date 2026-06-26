//
//  EmptyStateView.swift
//  PushLogic
//
//  Generic empty-state placeholder. Optionally renders a call-to-action
//  button via a caller-supplied title and closure.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var systemImage: String = "tray"
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: systemImage)
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(AppColors.secondaryText)

            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppTypography.title3)
                    .foregroundStyle(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }

            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(AppSpacing.xl)
        .frame(maxWidth: .infinity)
    }
}
