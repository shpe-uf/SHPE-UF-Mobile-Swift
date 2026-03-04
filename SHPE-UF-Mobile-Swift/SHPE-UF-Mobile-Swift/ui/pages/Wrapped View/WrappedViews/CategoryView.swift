//
//  CategoryView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 11/5/25.
//

import SwiftUI

struct TypingText: View {
    let text: String
    let font: Font
    let color: Color
    let typingSpeed: Double

    @State private var displayed = ""

    var body: some View {
        ZStack(alignment: .center) {

            // Placeholder to lock height
            Text(text)
                .font(font)
                .opacity(0)
                .multilineTextAlignment(.center)

            // Typing text
            Text(displayed)
                .font(font)
                .foregroundColor(color)
                .multilineTextAlignment(.center)
        }
        .onAppear {
            displayed = ""
            for (i, ch) in text.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + typingSpeed * Double(i)) {
                    displayed.append(ch)
                }
            }
        }
    }
}

struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var vm: WrappedViewModel

    @State private var showTitle = false
    @State private var showCategory = false
    @State private var showDetail = false

    private let impact = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Spacer()

                // MARK: - Title
                if showTitle {
                    Text("Top Category")
                        .font(.custom("Viga", size: 36))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .top).combined(with: .opacity)
                            )
                        )
                }

                
                // MARK: - Category
                if showCategory {
                    TypingText(
                        text: vm.topCategory,
                        font: .custom("Viga", size: 52),
                        color: Color.profileOrange,
                        typingSpeed: 0.09
                    )
                    .multilineTextAlignment(.center)
                    .transition(.opacity.combined(with: .scale))
                    .shadow(color: Color.orangeButton.opacity(0.2), radius: 8, x: 0, y: 8)
                    .padding(.top, 25)
                }
                   

                Spacer()

                // MARK: - Detail
                Text("You attended \n\(vm.topcategoryCount) \(vm.topCategory) events")
                    .font(.custom("Viga", size: 24))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .multilineTextAlignment(.center)
                    .opacity(showDetail ? 1 : 0)
                    .offset(y: showDetail ? 0 : 10)

                Spacer()
            }
        }
        .animation(.easeOut(duration: 0.45), value: showTitle)
        .onAppear {
            resetAnimations()
            impact.prepare()

            // Title
            withAnimation(.easeOut(duration: 0.35)) {
                showTitle = true
            }

            // Category
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                impact.impactOccurred()
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showCategory = true
                }
            }

            // Detail
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                withAnimation(.easeOut(duration: 0.3)) {
                    showDetail = true
                }
            }
        }
    }

    private func resetAnimations() {
        showTitle = false
        showCategory = false
        showDetail = false
    }
}

#Preview {

    CategoryView(vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:]))
    .preferredColorScheme(.dark)
}
