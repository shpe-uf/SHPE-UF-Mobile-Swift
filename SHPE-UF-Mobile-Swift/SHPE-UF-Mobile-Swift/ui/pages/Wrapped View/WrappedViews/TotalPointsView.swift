//
//  TotalPointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 12/22/25.
//

import SwiftUI

struct TotalPointsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let totalPoints: Int
    let percentile: Int

    @State private var animatedPoints: Int = 0
    @State private var showTitle = false
    @State private var showPercentile = false
    @State private var scale: CGFloat = 0.8

    private let impact = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        ZStack {

            VStack(spacing: 12) {
                Spacer()

                // MARK: - Animated Number
                Text("\(animatedPoints)")
                    .font(.custom("Viga", size: 100, relativeTo: .largeTitle))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.profileOrange)
                    .scaleEffect(scale)
                    .shadow(
                        color: Color.profileOrange.opacity(0.45),
                        radius: 22,
                        y: 8
                    )

                // MARK: - Title
                Text("Total SHPoints")
                    .font(.custom("Viga", size: 30, relativeTo: .title))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 12)

                Spacer()

                // MARK: - Percentile
                Text("This puts you in the\nTOP \(percentile)% percentile")
                    .font(.custom("Viga", size: 25, relativeTo: .title))
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .opacity(showPercentile ? 1 : 0)
                    .offset(y: showPercentile ? 0 : 16)

                Spacer()
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        
        .onAppear {
            reset()
            runAnimation()
        }
    }

    private func runAnimation() {
        impact.prepare()

        // Count up
        let duration: Double = 1.6
        let steps = max(totalPoints, 1)
        let interval = duration / Double(steps)

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * interval) {
                animatedPoints = i
            }
        }

        // Emphasis bounce
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            impact.impactOccurred()
            withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
                scale = 1
            }
        }

        // Subtitle
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.25) {
            withAnimation(.easeOut(duration: 0.5)) {
                showTitle = true
            }
        }

        // Percentile
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.7) {
            withAnimation(.easeOut(duration: 0.6)) {
                showPercentile = true
            }
        }
    }

    private func reset() {
        animatedPoints = 0
        showTitle = false
        showPercentile = false
        scale = 0.8
    }
}

#Preview {
    TotalPointsView(totalPoints: 21, percentile: 89)
        .preferredColorScheme(ColorScheme.light)
}
