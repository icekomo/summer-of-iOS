//
//  DashboardView.swift
//  PushLogic
//
//  Home tab screen. Drives all sections from DashboardViewModel, which
//  reads from the activity and challenge repositories via AppEnvironment.
//  Friend Activity still uses mock data — there is no friends repository
//  yet.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(AppEnvironment.self) private var environment: AppEnvironment?
    @State private var viewModel: DashboardViewModel?

    private static let amber = Color(red: 0.96, green: 0.78, blue: 0.30)

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                DashboardHeader()

                if let viewModel {
                    TodayProgressCard(
                        current: viewModel.todayPushups,
                        goal: viewModel.todayGoal,
                        streakDays: viewModel.currentStreak
                    )
                    statisticsRow(viewModel: viewModel)
                    WeeklyStreakCard(days: viewModel.weekDays)
                    ActivityChartCard(
                        weeklyData: viewModel.weeklyChartData,
                        monthlyData: viewModel.monthlyChartData
                    )
                    ActiveChallengesSection(challenges: viewModel.activeChallenges)
                    FriendActivitySection()
                } else {
                    LoadingView()
                        .frame(minHeight: 400)
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.top, AppSpacing.lg)
            .padding(.bottom, AppSpacing.huge)
        }
        .scrollIndicators(.hidden)
        .background(AppColors.background.ignoresSafeArea())
        .task { await load() }
    }

    // MARK: Sections

    private func statisticsRow(viewModel: DashboardViewModel) -> some View {
        HStack(spacing: AppSpacing.md) {
            DashboardStatCard(
                systemImage: "flame.fill",
                iconTint: AppColors.primary,
                iconBackground: AppColors.accent,
                value: "\(viewModel.dayStreak)",
                title: "Day Streak"
            )
            DashboardStatCard(
                systemImage: "trophy.fill",
                iconTint: Self.amber,
                iconBackground: Self.amber.opacity(0.18),
                value: "\(viewModel.bestDay)",
                title: "Best Day"
            )
            DashboardStatCard(
                systemImage: "chart.line.uptrend.xyaxis",
                iconTint: AppColors.accent,
                iconBackground: AppColors.accent.opacity(0.18),
                value: "\(viewModel.thisWeek)",
                title: "This Week"
            )
        }
    }

    // MARK: Lifecycle

    private func load() async {
        guard let environment else { return }
        if viewModel == nil {
            viewModel = DashboardViewModel(
                challenges: environment.repositories.challenges,
                activities: environment.repositories.activities
            )
        }
        viewModel?.refresh()
    }
}

#Preview("Dashboard") {
    let schema = Schema([
        Challenge.self,
        Participant.self,
        ActivityRecord.self,
        Achievement.self,
        UserSettings.self
    ])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: config)
    let context = container.mainContext
    let repos = RepositoryContainer(
        challenges: ChallengeRepository(context: context),
        activities: ActivityRepository(context: context),
        settings: SettingsRepository(context: context)
    )
    let env = AppEnvironment(repositories: repos, router: AppRouter())

    return DashboardView()
        .environment(env)
        .preferredColorScheme(.dark)
}
