//
//  DashboardSectionHeader.swift
//  PushLogic
//
//  Reusable section heading for the dashboard: title on the left,
//  optional "See All" + chevron action on the right.
//

import SwiftUI

struct DashboardSectionHeader: View {
    let title: String
    var actionTitle: String = "See All"
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(AppTypography.title3)
                .foregroundStyle(AppColors.primaryText)

            Spacer(minLength: AppSpacing.md)

            if let action {
                Button(action: action) {
                    HStack(spacing: AppSpacing.xs) {
                        Text(actionTitle)
                            .font(AppTypography.subheadline)
                            .fontWeight(.semibold)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(AppColors.accent)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(actionTitle) \(title)")
            }
        }
    }
}

#Preview("Section Header") {
    VStack(alignment: .leading, spacing: AppSpacing.lg) {
        DashboardSectionHeader(title: "Push Groups") {}
        DashboardSectionHeader(title: "Friend Activity") {}
        DashboardSectionHeader(title: "No Action")
    }
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
