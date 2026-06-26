//
//  GradientBackground.swift
//  PushLogic
//
//  Full-bleed gradient background. Defaults to the brand gradient but
//  any LinearGradient can be supplied.
//

import SwiftUI

struct GradientBackground: View {
    var gradient: LinearGradient = AppGradients.brand
    var ignoresSafeArea: Bool = true

    var body: some View {
        Group {
            if ignoresSafeArea {
                gradient.ignoresSafeArea()
            } else {
                gradient
            }
        }
    }
}
