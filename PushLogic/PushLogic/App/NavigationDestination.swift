//
//  NavigationDestination.swift
//  PushLogic
//
//  The four root destinations the bottom navigation bar selects between.
//  Reserved separately from the FAB action so the FAB never becomes a
//  selected tab.
//

import Foundation

enum NavigationDestination: String, Hashable, CaseIterable, Identifiable {
    case home
    case friends
    case history
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .friends: return "Friends"
        case .history: return "History"
        case .settings: return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .friends: return "person.2.fill"
        case .history: return "arrow.counterclockwise"
        case .settings: return "gearshape.fill"
        }
    }
}
