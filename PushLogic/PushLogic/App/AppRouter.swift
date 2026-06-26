//
//  AppRouter.swift
//  PushLogic
//
//  High-level navigation coordinator. Owns a NavigationState and
//  exposes the actions feature views call into. Feature views should
//  never mutate NavigationState directly — they call AppRouter.
//

import SwiftUI

@Observable
final class AppRouter {
    let state: NavigationState

    init(state: NavigationState = NavigationState()) {
        self.state = state
    }

    // MARK: Tab selection

    func select(_ destination: NavigationDestination) {
        state.selectedDestination = destination
    }

    func popToRoot(_ destination: NavigationDestination) {
        switch destination {
        case .home: state.homePath = NavigationPath()
        case .friends: state.friendsPath = NavigationPath()
        case .history: state.historyPath = NavigationPath()
        case .settings: state.settingsPath = NavigationPath()
        }
    }

    // MARK: Floating action button

    func presentCreateChallenge() {
        state.isPresentingCreateChallenge = true
    }

    func dismissCreateChallenge() {
        state.isPresentingCreateChallenge = false
    }
}
