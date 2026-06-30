//
//  ChallengeNameSection.swift
//  PushLogic
//
//  Section for naming a challenge: section label, large text editor
//  with character limit + counter, and a row of quick-tag emoji chips
//  that append to the name when tapped. Pure presentation — caller
//  owns the binding, no persistence, no validation beyond the limit.
//

import SwiftUI

struct ChallengeNameSection: View {
    @Binding var name: String

    var characterLimit: Int = 40
    var placeholder: String = "e.g. Elite Pushers 500..."
    var helperText: String = "Give your challenge a memorable name"
    var quickTags: [String] = ["🔥", "💪", "⚡", "🏆", "🎯", "🚀"]

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            sectionLabel
            textCard
            quickTagsRow
        }
    }

    // MARK: Section label

    private var sectionLabel: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "pencil")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(AppColors.primary)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(Capsule().fill(AppColors.accent))
            Text("CHALLENGE NAME")
                .font(AppTypography.caption)
                .fontWeight(.semibold)
                .tracking(1.4)
                .foregroundStyle(AppColors.secondaryText)
        }
    }

    // MARK: Text editor card

    private var textCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            TextField(
                "",
                text: $name,
                prompt: Text(placeholder)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText.opacity(0.3))
            )
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(AppColors.primaryText)
            .tint(AppColors.accent)
            .textInputAutocapitalization(.words)
            .onChange(of: name) { _, newValue in
                if newValue.count > characterLimit {
                    name = String(newValue.prefix(characterLimit))
                }
            }

            HStack {
                Text(helperText)
                    .font(AppTypography.footnote)
                    .foregroundStyle(AppColors.secondaryText)
                Spacer()
                Text("\(name.count)/\(characterLimit)")
                    .font(AppTypography.footnote)
                    .foregroundStyle(
                        name.count >= characterLimit
                            ? AppColors.accent
                            : AppColors.secondaryText
                    )
                    .monospacedDigit()
            }
        }
        .padding(AppSpacing.lg)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .strokeBorder(AppColors.separator.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: Quick tags

    private var quickTagsRow: some View {
        HStack(spacing: AppSpacing.sm) {
            Text("Quick tag:")
                .font(AppTypography.footnote)
                .foregroundStyle(AppColors.secondaryText)
            ForEach(quickTags, id: \.self) { tag in
                tagChip(tag)
            }
            Spacer(minLength: 0)
        }
    }

    private func tagChip(_ tag: String) -> some View {
        Button {
            append(tag)
        } label: {
            Text(tag)
                .font(.system(size: 18))
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.secondaryBackground)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(AppColors.separator.opacity(0.6), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Add tag \(tag)")
    }

    private func append(_ tag: String) {
        let proposed = name + tag
        guard proposed.count <= characterLimit else { return }
        name = proposed
    }
}

#Preview("Challenge Name") {
    @Previewable @State var name: String = ""
    return ChallengeNameSection(name: $name)
        .padding()
        .background(AppColors.background)
        .preferredColorScheme(.dark)
}
