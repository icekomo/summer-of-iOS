//
//  AppAnimation.swift
//  PushLogic
//
//  Centralized animation curves and durations. Subtle and purposeful
//  per Apple's HIG — avoid gratuitous motion.
//

import SwiftUI

enum AppAnimation {
    // MARK: Standard durations

    static let quick = Animation.easeInOut(duration: 0.15)
    static let standard = Animation.easeInOut(duration: 0.25)
    static let slow = Animation.easeInOut(duration: 0.4)

    // MARK: Springs

    /// Snappy press feedback for buttons.
    static let buttonSpring = Animation.spring(response: 0.3, dampingFraction: 0.6)

    /// Lift / press effect for cards.
    static let cardLift = Animation.spring(response: 0.4, dampingFraction: 0.7)

    /// Progress ring fill — gentle settle.
    static let progressRing = Animation.spring(response: 0.6, dampingFraction: 0.85)

    // MARK: Specialized

    /// Smooth counter increment animation.
    static let counter = Animation.smooth(duration: 0.25)

    /// Gradient interpolation when progress changes.
    static let gradient = Animation.easeInOut(duration: 0.5)

    /// Sheet / modal presentation curve.
    static let presentation = Animation.spring(response: 0.45, dampingFraction: 0.85)
}
