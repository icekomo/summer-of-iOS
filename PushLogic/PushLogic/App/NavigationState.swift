//
//  NavigationState.swift
//  PushLogic
//
//  Observable container for navigation state — selected destination,
//  per-destination NavigationPath, and modal presentation flags.
//  AppRouter mutates this; views observe it.
//

import SwiftUI

@Observable
final class NavigationState {
    // Selection
    var selectedDestination: NavigationDestination = .home

    // Per-destination navigation stacks
    var homePath = NavigationPath()
    var friendsPath = NavigationPath()
    var historyPath = NavigationPath()
    var settingsPath = NavigationPath()

    // FAB modal
    var isPresentingCreateChallenge: Bool = false

    // Reserved for future use — badges per destination, deep-link payloads.
    var badges: [NavigationDestination: Int] = [:]

    func badge(for destination: NavigationDestination) -> Int? {
        guard let value = badges[destination], value > 0 else { return nil }
        return value
    }
}
