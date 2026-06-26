# PushLogic

## Architecture.md

Version 1.0

------------------------------------------------------------------------

# Overview

PushLogioc is a native iOS application that helps users create, track, and
complete push-up challenges.

The first version is completely offline using SwiftData. The
architecture is intentionally designed so CloudKit or another backend
can be added later with minimal changes.

## Technology Stack

-   SwiftUI
-   SwiftData
-   Observation Framework (`@Observable`)
-   NavigationStack
-   MVVM
-   Repository Pattern
-   Protocol-Oriented Programming
-   Dependency Injection
-   Swift Charts
-   AppStorage
-   Local Notifications

**Minimum iOS:** iOS 18

------------------------------------------------------------------------

# Architecture

``` text
Views
    ↓
ViewModels
    ↓
Repositories
    ↓
SwiftData
```

Views never communicate directly with SwiftData.

Views never contain business logic.

Repositories are the only objects that know how data is stored.

------------------------------------------------------------------------

# Folder Structure

``` text
Push

├── App
│   ├── PushApp.swift
│   ├── AppRouter.swift
│   ├── AppEnvironment.swift
│
├── Core
│   ├── Theme
│   │   ├── AppColors.swift
│   │   ├── AppTypography.swift
│   │   ├── AppSpacing.swift
│   │   ├── AppGradients.swift
│   │   └── AppButtonStyle.swift
│   ├── Components
│   │   ├── PrimaryButton.swift
│   │   ├── ProgressRing.swift
│   │   ├── ChallengeCard.swift
│   │   ├── EmptyStateView.swift
│   │   ├── LoadingView.swift
│   │   └── StatCard.swift
│   ├── Models
│   │   ├── Challenge.swift
│   │   ├── Participant.swift
│   │   ├── ActivityRecord.swift
│   │   ├── Achievement.swift
│   │   └── UserSettings.swift
│   ├── Repositories
│   │   ├── ChallengeRepository.swift
│   │   ├── ChallengeRepositoryProtocol.swift
│   │   ├── ActivityRepository.swift
│   │   ├── SettingsRepository.swift
│   │   └── RepositoryContainer.swift
│   ├── Services
│   │   ├── NotificationService.swift
│   │   ├── HapticService.swift
│   │   ├── GradientService.swift
│   │   ├── AchievementService.swift
│   │   └── StatisticsService.swift
│   ├── Extensions
│   └── Utilities
├── Features
│   ├── Splash
│   ├── Home
│   ├── Challenge
│   ├── Counter
│   ├── Activity
│   ├── Settings
│   └── Onboarding
└── Resources
    ├── Assets.xcassets
    └── Preview Content
```

------------------------------------------------------------------------

# MVVM

``` text
HomeView
   ↓
HomeViewModel
   ↓
ChallengeRepository
   ↓
SwiftData
```

Views never perform persistence.

------------------------------------------------------------------------

# Models

## Challenge

Properties

-   id
-   title
-   goalPushups
-   currentPushups
-   startDate
-   endDate
-   createdDate
-   isCompleted
-   participants

Computed

-   progress
-   remainingPushups
-   daysRemaining
-   completionPercentage

## Participant

-   id
-   name
-   avatar
-   progress
-   future: appleUserID

## ActivityRecord

-   date
-   pushups
-   challengeID

## Achievement

-   title
-   icon
-   dateEarned
-   type

## UserSettings

-   notificationsEnabled
-   hapticsEnabled
-   theme
-   dailyReminder
-   displayName

------------------------------------------------------------------------

# Repository Layer

## ChallengeRepository

Responsible for:

-   Create Challenge
-   Delete Challenge
-   Update Challenge
-   Fetch Challenges
-   Finish Challenge

## ActivityRepository

Responsible for:

-   Save workout
-   Daily totals
-   Weekly totals
-   Statistics

## SettingsRepository

Responsible for saving preferences.

------------------------------------------------------------------------

# Services

## NotificationService

-   Daily reminders
-   Challenge ending reminders
-   Challenge completion notifications

## HapticService

Centralizes all haptic feedback.

## GradientService

Calculates the orange → purple gradient based on challenge completion
percentage.

## AchievementService

Unlocks achievements such as:

-   First 100 Push-ups
-   500 Push-ups
-   1000 Push-ups
-   7-Day Streak

## StatisticsService

Calculates:

-   Daily averages
-   Weekly totals
-   Monthly totals
-   Longest streak

------------------------------------------------------------------------

# Dependency Injection

``` text
RepositoryContainer
    ├── ChallengeRepository
    ├── ActivityRepository
    └── SettingsRepository
```

Inject repositories into ViewModels.

Never instantiate repositories inside Views.

------------------------------------------------------------------------

# Navigation

-   TabView
    -   Challenges
    -   Activity
    -   Settings

Each tab owns its own `NavigationStack`.

Use an `AppRouter` to coordinate navigation.

------------------------------------------------------------------------

# State Management

-   `@State` for local UI state
-   `@Bindable` for observable models
-   `@Environment` for shared dependencies
-   `@Query` only in controlled persistence layers

------------------------------------------------------------------------

# Reusable Components

-   ProgressRing
-   ChallengeCard
-   PrimaryButton
-   SecondaryButton
-   GradientBackground
-   EmptyStateView
-   LoadingView
-   StatCard
-   AvatarView
-   AchievementBadge

Components receive data only---they do not know about persistence.

------------------------------------------------------------------------

# Theme

Centralize:

-   Colors
-   Fonts
-   Spacing
-   Corner radius
-   Animations

Never hardcode styling values.

------------------------------------------------------------------------

# Animation Philosophy

Use subtle animations:

-   Progress ring fill
-   Number counting
-   Gradient interpolation
-   Button spring
-   Card lift
-   Confetti on challenge completion

------------------------------------------------------------------------

# Error Handling

Repositories throw errors or return `Result`.

ViewModels decide how to respond.

Views only display alerts.

------------------------------------------------------------------------

# Future CloudKit Support

Use protocols:

``` text
ChallengeRepositoryProtocol
        ↓
SwiftDataChallengeRepository
        ↓
CloudKitChallengeRepository (future)
```

No ViewModel changes required.

------------------------------------------------------------------------

# Testing Strategy

## Unit Tests

-   ChallengeRepository
-   StatisticsService
-   AchievementService
-   GradientService
-   CounterViewModel
-   ChallengeViewModel

## UI Tests

-   Create Challenge
-   Delete Challenge
-   Counter
-   Settings
-   Navigation

------------------------------------------------------------------------

# Accessibility

-   Dynamic Type
-   VoiceOver
-   Reduce Motion
-   High Contrast
-   Large tap targets
-   Color-independent progress indicators

------------------------------------------------------------------------

# Performance Goals

-   Fast launch
-   Smooth animations
-   Instant local data loading
-   Minimal view redraws
-   Clear separation of concerns

------------------------------------------------------------------------

# Roadmap

## Version 1

-   Local SwiftData storage
-   Notifications
-   Activity history
-   Achievements

## Version 2

-   CloudKit sync
-   Apple Health
-   Widgets
-   Live Activities
-   Siri Shortcuts

## Version 3

-   Friend invitations
-   Shared challenges
-   Leaderboards
-   Social interactions

------------------------------------------------------------------------

# Development Rules

1.  Keep Views focused on presentation.
2.  Put business logic in ViewModels or Services.
3.  Access persistence only through repositories.
4.  Build reusable components before duplicating UI.
5.  Prefer SwiftUI-native APIs.
6.  Favor composition over inheritance.
7.  Document public APIs.
8.  Write testable, modular code.
9.  Keep each file focused on a single responsibility.
10. Avoid unnecessary third-party dependencies.
