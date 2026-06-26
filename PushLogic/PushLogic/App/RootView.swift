//
//  RootView.swift
//  PushLogic
//
//  Switches between the four root NavigationStacks based on
//  NavigationState. Hosts the custom BottomNavigationBar and presents
//  the Create Challenge modal when the FAB is tapped.
//

import SwiftUI

struct RootView: View {
    @State private var router = AppRouter()

    var body: some View {
        @Bindable var state = router.state

        ZStack(alignment: .bottom) {
            destinationStack(state: state)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            BottomNavigationBar(
                selected: $state.selectedDestination,
                badges: { state.badge(for: $0) },
                onFABTap: { router.presentCreateChallenge() }
            )
        }
        .background(AppColors.background.ignoresSafeArea())
        .fullScreenCover(isPresented: $state.isPresentingCreateChallenge) {
            CreateChallengePlaceholder {
                router.dismissCreateChallenge()
            }
        }
        .environment(router)
    }

    @ViewBuilder
    private func destinationStack(state: NavigationState) -> some View {
        @Bindable var state = state
        switch state.selectedDestination {
        case .home:
            NavigationStack(path: $state.homePath) {
                DashboardView()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .transition(.opacity)
        case .friends:
            NavigationStack(path: $state.friendsPath) {
                DestinationPlaceholder(destination: .friends)
            }
            .transition(.opacity)
        case .history:
            NavigationStack(path: $state.historyPath) {
                DestinationPlaceholder(destination: .history)
            }
            .transition(.opacity)
        case .settings:
            NavigationStack(path: $state.settingsPath) {
                DestinationPlaceholder(destination: .settings)
            }
            .transition(.opacity)
        }
    }
}

// MARK: - Placeholders

/// Stand-in root view for each destination until feature screens land.
private struct DestinationPlaceholder: View {
    let destination: NavigationDestination

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: destination.systemImage)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(AppColors.accent)
            Text(destination.title)
                .font(AppTypography.largeTitle)
                .foregroundStyle(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.background)
        .navigationTitle(destination.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Stand-in modal shown when the FAB is tapped. Real Create Challenge
/// flow will replace this.
private struct CreateChallengePlaceholder: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            VStack(spacing: AppSpacing.xl) {
                Image(systemName: "plus.circle.dashed")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(AppColors.accent)
                Text("Create Challenge")
                    .font(AppTypography.title)
                    .foregroundStyle(AppColors.primaryText)
                Text("Flow coming soon")
                    .font(AppTypography.subheadline)
                    .foregroundStyle(AppColors.secondaryText)
                PrimaryButton(title: "Close", action: onDismiss)
                    .padding(.horizontal, AppSpacing.xl)
            }
            .padding(AppSpacing.xl)
        }
    }
}

#Preview {
    RootView()
}
