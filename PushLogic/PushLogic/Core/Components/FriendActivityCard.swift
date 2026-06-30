//
//  FriendActivityCard.swift
//  PushLogic
//
//  Reusable row for the dashboard's Friend Activity feed. Supports four
//  activity kinds and an optional trailing action button (e.g. "Join"
//  for challenge invites). Pure presentation — no networking, no
//  persistence.
//

import SwiftUI

struct FriendActivityCard: View {
    enum ActivityKind {
        case joined
        case completed
        case newPersonalBest
        case challengeInvite

        var systemImage: String {
            switch self {
            case .joined: return "figure.strengthtraining.traditional"
            case .completed: return "checkmark.seal.fill"
            case .newPersonalBest: return "flame.fill"
            case .challengeInvite: return "envelope.fill"
            }
        }

        var tint: Color {
            switch self {
            case .joined: return AppColors.accent
            case .completed: return AppColors.accent
            case .newPersonalBest: return Color(red: 1.0, green: 0.55, blue: 0.20)
            case .challengeInvite: return AppColors.accent
            }
        }
    }

    let name: String
    let message: String
    let timestamp: String
    var context: String? = nil
    var avatar: AvatarView.Source = .systemImage("person.fill")
    var kind: ActivityKind = .joined
    var actionTitle: String? = nil
    var onAction: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center, spacing: AppSpacing.md) {
            AvatarView(
                source: avatar,
                size: 44,
                backgroundColor: AppColors.accent.opacity(0.18),
                foregroundColor: AppColors.accent
            )

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                title
                metadata
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            trailing
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .strokeBorder(AppColors.separator.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: Title / message

    private var title: some View {
        (
            Text(name)
                .font(AppTypography.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColors.accent)
            + Text(" \(message)")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.primaryText)
        )
        .lineLimit(2)
    }

    private var metadata: some View {
        HStack(spacing: AppSpacing.xs) {
            Text(timestamp)
                .font(AppTypography.caption)
                .foregroundStyle(AppColors.secondaryText)
            if let context {
                Text("·")
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                Text(context)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColors.secondaryText)
                    .lineLimit(1)
            }
        }
    }

    // MARK: Trailing

    @ViewBuilder
    private var trailing: some View {
        if let actionTitle, let onAction {
            Button(action: onAction) {
                Text(actionTitle)
                    .font(AppTypography.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.onAccent)
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.vertical, AppSpacing.sm)
                    .background(Capsule().fill(AppColors.accent))
            }
            .buttonStyle(.plain)
        } else {
            Image(systemName: kind.systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(kind.tint)
                .frame(width: 36, height: 36)
        }
    }
}

#Preview("Friend Activity") {
    VStack(spacing: AppSpacing.md) {
        FriendActivityCard(
            name: "Marcus",
            message: "logged 50 push-ups",
            timestamp: "2 min ago",
            context: "Morning Crushers",
            avatar: .initials("MA"),
            kind: .joined
        )
        FriendActivityCard(
            name: "Priya",
            message: "hit a new PB! 137 reps",
            timestamp: "14 min ago",
            context: "Office Challengers",
            avatar: .initials("PR"),
            kind: .newPersonalBest
        )
        FriendActivityCard(
            name: "Jordan",
            message: "completed the 30-day challenge",
            timestamp: "1 hr ago",
            avatar: .initials("JO"),
            kind: .completed
        )
        FriendActivityCard(
            name: "Tom",
            message: "started a 7-day challenge",
            timestamp: "1 hr ago",
            context: "Join now",
            avatar: .initials("TO"),
            kind: .challengeInvite,
            actionTitle: "Join",
            onAction: {}
        )
    }
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
