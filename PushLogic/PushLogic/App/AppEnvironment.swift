//
//  AppEnvironment.swift
//  PushLogic
//
//  Root dependency container injected via SwiftUI's Environment.
//

import SwiftUI

@Observable
final class AppEnvironment {
    let repositories: RepositoryContainer
    let router: AppRouter

    init(repositories: RepositoryContainer, router: AppRouter) {
        self.repositories = repositories
        self.router = router
    }
}
