//
//  StatCard.swift
//  PushLogic
//
//  Generic stat tile for dashboards. Renders a label, value, and
//  optional icon — no business logic.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    var systemImage: String? = nil
    var tint: Color = AppColors.accent

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.xs) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .foregroundStyle(tint)
                }
                Text(title)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .textCase(.uppercase)
            }
            Text(value)
                .font(AppTypography.statMedium)
                .foregroundStyle(AppColors.primaryText)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
    }
}
