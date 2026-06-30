//
//  SplashView.swift
//  PushLogic
//
//  Minimal launch screen — animated brand gradient, logo, wordmark, and
//  a small loader. Calls `onFinish` after two seconds. The caller is
//  responsible for wiring that closure into navigation.
//

import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void = {}

    @State private var gradientPhase: Bool = false
    @State private var logoScale: Double = 0.85
    @State private var contentOpacity: Double = 0

    var body: some View {
        ZStack {
            animatedGradient

            VStack(spacing: AppSpacing.xl) {
                Spacer()
                logo
                wordmark
                Spacer()
                loader
                    .padding(.bottom, AppSpacing.xxxl)
            }
            .opacity(contentOpacity)
        }
        .onAppear { startEntranceAnimation() }
        .task { await scheduleFinish() }
    }

    // MARK: Subviews

    private var animatedGradient: some View {
        LinearGradient(
            colors: [AppColors.primary, AppColors.accent],
            startPoint: gradientPhase ? .topLeading : .bottomLeading,
            endPoint: gradientPhase ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .animation(
            .easeInOut(duration: 3).repeatForever(autoreverses: true),
            value: gradientPhase
        )
    }

    private var logo: some View {
        Image(systemName: "figure.strengthtraining.traditional")
            .font(.system(size: 96, weight: .bold))
            .foregroundStyle(AppColors.onPrimary)
            .scaleEffect(logoScale)
            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
    }

    private var wordmark: some View {
        Text("Push Logic")
            .font(AppTypography.largeTitle)
            .foregroundStyle(AppColors.onPrimary)
            .tracking(1.5)
    }

    private var loader: some View {
        ProgressView()
            .controlSize(.regular)
            .tint(AppColors.onPrimary)
    }

    // MARK: Lifecycle

    private func startEntranceAnimation() {
        gradientPhase = true
        withAnimation(.spring(response: 0.7, dampingFraction: 0.7)) {
            logoScale = 1.0
            contentOpacity = 1
        }
    }

    private func scheduleFinish() async {
        try? await Task.sleep(for: .seconds(2))
        onFinish()
    }
}

#Preview("Splash") {
    SplashView()
        .preferredColorScheme(.dark)
}
