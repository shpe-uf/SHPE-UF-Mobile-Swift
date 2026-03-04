//
//  YearsBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//

import SwiftUI

/// **OverallView:** Final identity reveal
struct OverallView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var vm: WrappedViewModel

    @State private var showPrefix = false
    @State private var showCabinet = false

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

            VStack(spacing: 12) {
                Spacer()

                // MARK: - Prefix
                Text("You are a…")
                    .font(.custom("Viga", size: 36))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .opacity(showPrefix ? 1 : 0)
                    .offset(y: showPrefix ? 0 : 12)

                // MARK: - Cabinet
                Text("\(vm.overallTitle) Enthusiast!")
                    .font(.custom("Viga", size: 52))
                    .foregroundColor(orange)
                    .scaleEffect(showCabinet ? 1 : 0.75)
                    .opacity(showCabinet ? 1 : 0)
                    .blur(radius: showCabinet ? 0 : 14)
                    .offset(y: showCabinet ? 0 : 20)
                    .multilineTextAlignment(.center)

                Spacer()
            }
        }
        .onAppear {
            reset()

            impact.prepare()

            // Step 1: Prefix
            withAnimation(.easeOut(duration: 2)) {
                showPrefix = true
            }

            // Step 2: Cabinet Reveal
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                impact.impactOccurred()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCabinet = true
                }
            }
        }
    }

    private func reset() {
        showPrefix = false
        showCabinet = false
    }
}

#Preview {
    OverallView(vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:]))
}

