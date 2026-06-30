//
//  ActivityChartCard.swift
//  PushLogic
//
//  Bar chart card for the dashboard's activity section. Built on Swift
//  Charts. Knows nothing about persistence — caller passes in weekly
//  and monthly DataPoint arrays.
//

import SwiftUI
import Charts

struct ActivityChartCard: View {
    struct DataPoint: Identifiable {
        let id = UUID()
        let label: String
        let value: Int
        var isCurrent: Bool = false
    }

    enum Range: String, CaseIterable, Identifiable {
        case weekly = "W"
        case monthly = "M"
        var id: String { rawValue }
    }

    let weeklyData: [DataPoint]
    let monthlyData: [DataPoint]
    var title: String = "7-Day Activity"

    @State private var selectedRange: Range = .weekly

    private var displayedData: [DataPoint] {
        selectedRange == .weekly ? weeklyData : monthlyData
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.lg) {
            header
            chart
        }
        .padding(AppSpacing.lg)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .fill(AppColors.secondaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.lg, style: .continuous)
                .strokeBorder(AppColors.separator.opacity(0.5), lineWidth: 1)
        )
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Text(title)
                .font(AppTypography.headline)
                .foregroundStyle(AppColors.primaryText)
            Spacer()
            rangeToggle
        }
    }

    private var rangeToggle: some View {
        HStack(spacing: 4) {
            ForEach(Range.allCases) { range in
                rangeButton(range)
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.04))
        )
    }

    private func rangeButton(_ range: Range) -> some View {
        let isSelected = selectedRange == range
        return Button {
            withAnimation(AppAnimation.buttonSpring) {
                selectedRange = range
            }
        } label: {
            Text(range.rawValue)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isSelected ? AppColors.accent : AppColors.secondaryText)
                .frame(width: 32, height: 26)
                .background(
                    RoundedRectangle(cornerRadius: 7, style: .continuous)
                        .fill(isSelected ? AppColors.accent.opacity(0.18) : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(range == .weekly ? "Weekly" : "Monthly")
    }

    // MARK: Chart

    private var chart: some View {
        Chart {
            ForEach(displayedData) { point in
                BarMark(
                    x: .value("Period", point.label),
                    y: .value("Push-ups", point.value),
                    width: .ratio(0.55)
                )
                .foregroundStyle(
                    point.isCurrent
                        ? AppColors.accent
                        : AppColors.accent.opacity(0.55)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic(desiredCount: 3)) { _ in
                AxisGridLine()
                    .foregroundStyle(Color.white.opacity(0.08))
                AxisValueLabel()
                    .foregroundStyle(AppColors.secondaryText)
                    .font(AppTypography.caption2)
            }
        }
        .chartXAxis {
            AxisMarks { _ in
                AxisValueLabel()
                    .foregroundStyle(AppColors.secondaryText)
                    .font(AppTypography.caption2)
            }
        }
        .chartPlotStyle { plot in
            plot.padding(.vertical, 4)
        }
        .frame(height: 200)
        .animation(AppAnimation.standard, value: selectedRange)
    }
}

#Preview("Activity Chart") {
    ActivityChartCard(
        weeklyData: [
            .init(label: "Mon", value: 180),
            .init(label: "Tue", value: 95),
            .init(label: "Wed", value: 220),
            .init(label: "Thu", value: 165),
            .init(label: "Fri", value: 127, isCurrent: true),
            .init(label: "Sat", value: 0),
            .init(label: "Sun", value: 0)
        ],
        monthlyData: [
            .init(label: "W1", value: 850),
            .init(label: "W2", value: 920),
            .init(label: "W3", value: 1050),
            .init(label: "W4", value: 780, isCurrent: true)
        ]
    )
    .padding()
    .background(AppColors.background)
    .preferredColorScheme(.dark)
}
