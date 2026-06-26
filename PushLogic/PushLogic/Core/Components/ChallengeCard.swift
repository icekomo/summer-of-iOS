//
//  ChallengeCard.swift
//  PushLogic
//
//  Generic card surface for displaying a challenge's headline info.
//  Receives already-computed values — no business logic, no persistence.
//

import SwiftUI

struct ChallengeCard: View {
    let title: String
    var subtitle: String? = nil
    let currentValue: Int
    let goalValue: Int
    var trailingDetail: String? = nil

    private var progress: Double {
        guard goalValue > 0 else { return 0 }
        return min(1, max(0, Double(currentValue) / Double(goalValue)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            header

            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xs) {
                Text("\(currentValue)")
                    .font(AppTypography.statMedium)
                    .foregroundStyle(AppColors.primaryText)
                Text("/ \(goalValue)")
                    .font(AppTypography.callout)
                    .foregroundStyle(AppColors.secondaryText)
            }

            progressBar
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(title)
                    .font(AppTypography.headline)
                    .foregroundStyle(AppColors.primaryText)
                if let subtitle {
                    Text(subtitle)
                        .font(AppTypography.subheadline)
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
            Spacer()
            if let trailingDetail {
                Text(trailingDetail)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(AppColors.tertiaryBackground)
                Capsule()
                    .fill(AppGradients.brandHorizontal)
                    .frame(width: geo.size.width * progress)
                    .animation(AppAnimation.progressRing, value: progress)
            }
        }
        .frame(height: 8)
    }
}
