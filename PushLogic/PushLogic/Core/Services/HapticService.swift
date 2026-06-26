//
//  HapticService.swift
//  PushLogic
//
//  Centralizes haptic feedback so call sites stay one-liner and the
//  generator lifecycle / prepare-then-fire pattern lives in one place.
//

import UIKit

final class HapticService {
    /// Fires an impact haptic. Defaults to medium intensity.
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }

    /// Fires a selection-changed haptic — use for picker / toggle transitions.
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    /// Fires a notification haptic of the given type.
    func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    func success() { notify(.success) }
    func warning() { notify(.warning) }
    func error() { notify(.error) }
}
