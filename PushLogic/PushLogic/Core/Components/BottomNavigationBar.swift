//
//  BottomNavigationBar.swift
//  PushLogic
//
//  Reusable bottom navigation. Layouts four destinations around a
//  center FAB. Knows nothing about features — receives the selected
//  destination as a Binding plus an `onFABTap` closure.
//

import SwiftUI

struct BottomNavigationBar: View {
    @Binding var selected: NavigationDestination
    var badges: (NavigationDestination) -> Int? = { _ in nil }
    let onFABTap: () -> Void

    private let leading: [NavigationDestination] = [.home, .friends]
    private let trailing: [NavigationDestination] = [.history, .settings]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(leading) { destination in
                item(for: destination)
            }
            FloatingActionButton(action: onFABTap)
            ForEach(trailing) { destination in
                item(for: destination)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.sm)
        .frame(height: 84)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppColors.primary)
                .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 6)
        )
        .padding(.horizontal, AppSpacing.md)
    }

    private func item(for destination: NavigationDestination) -> some View {
        BottomNavigationItem(
            destination: destination,
            isSelected: selected == destination,
            badge: badges(destination),
            action: { select(destination) }
        )
    }

    private func select(_ destination: NavigationDestination) {
        guard selected != destination else { return }
        withAnimation(AppAnimation.buttonSpring) {
            selected = destination
        }
    }
}
