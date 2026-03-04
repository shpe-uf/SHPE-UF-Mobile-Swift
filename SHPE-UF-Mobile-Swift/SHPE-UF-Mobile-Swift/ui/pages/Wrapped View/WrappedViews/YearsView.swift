//
//  YearsBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//

import SwiftUI

/// **YearsBannerView:** Swift wrapped popup
struct YearsView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var vm: WrappedViewModel

    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showFooter = false
    @State private var animatedYears = 0

    private let impact = UIImpactFeedbackGenerator(style: .medium)

    private var orange: Color {
        colorScheme == .dark
        ? Color(red: 253/255, green: 101/255, blue: 47/255)
        : Color(red: 211/255, green: 58/255, blue: 2/255)
    }

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 12) {

                    Text(animatedYears == 1 ? "1 year!" : "\(animatedYears) years!")
                        .font(.custom("Viga", size: 56))
                        .foregroundColor(orange)
                        .scaleEffect(showTitle ? 1 : 0.7)
                        .opacity(showTitle ? 1 : 0)
                        .blur(radius: showTitle ? 0 : 12)
                        .offset(y: showTitle ? 0 : 24)

                    // Subtitle
                    Text("Since you first became a SHPEito")
                        .font(.custom("Viga", size: 36))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .multilineTextAlignment(.center)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 20)
                }

                Spacer()

                // Footer
                Text("Thank you for being a part of the familia 💙")
                    .font(.custom("Viga", size: 26))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                    .opacity(showFooter ? 1 : 0)
                    .offset(y: showFooter ? 0 : 24)
            }
        }
        .onAppear {
            resetAnimations()

            impact.prepare()

            // Title
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showTitle = true
            }

            impact.impactOccurred()
            animateYearCount()

            // Subtitle
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeOut(duration: 0.45)) {
                    showSubtitle = true
                }
            }

            // Footer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation(.easeOut(duration: 0.45)) {
                    showFooter = true
                }
            }
        }
    }

    private func resetAnimations() {
        showTitle = false
        showSubtitle = false
        showFooter = false
        animatedYears = 0
    }

    private func animateYearCount() {
        let target = max(vm.yearsInSHPE, 1)
        let duration = 1.0
        let interval = duration / Double(target)

        for i in 1...target {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                animatedYears = i
            }
        }
    }
}

#Preview {
    YearsView(vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:]))
        .preferredColorScheme(.dark)
}

