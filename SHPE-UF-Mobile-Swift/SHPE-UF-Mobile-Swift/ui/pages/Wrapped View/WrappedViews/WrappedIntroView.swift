//
//  ContentView.swift
//  Wrapped
//
//  Created by David Denis on 9/18/25.
//

import SwiftUI

enum WrappedPhase {
    case intro
    case transition
    case showMonth
}

struct WrappedIntroView: View {
    @Environment(\.colorScheme) var colorScheme
    // MARK: - Constants
    let text = "SHPE WRAPPED SHPE WRAPPED SHPE WRAPPED "
    let navyColor = Color.darkdarkBlue
    let orangeColor = Color.profileOrange
    
    private let marqueeFont =
    UIFont(name: "Viga", size: 40) ?? .systemFont(ofSize: 72)
    
    // MARK: - State
    @State private var phase: WrappedPhase = .intro
    @State private var rotateToHorizontal = false
    @State private var currentText = "SHPE WRAPPED"
    @State private var showMonthDetails = false
    
    @State private var alreadyViewed = false
    
    @ObservedObject var vm : WrappedViewModel
    
    var body: some View {
        ZStack {
            // Background color + optional gradient pulse
            LinearGradient(
                colors: phase == .showMonth
                ? [Color.profileOrange, Color.topBlue]
                : [navyColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 2.0), value: phase)
            
            // MARK: - Content
            VStack(spacing: 15) {
                
                
                // Top Marquees
                if phase != .showMonth {
                    MarqueeView(text, font: marqueeFont)
                        .rotationEffect(.degrees(330))
                        .offset(y: phase == .transition ? -10 : 220)
                        .opacity(phase == .transition ? 0.3 : 1)
                        .animation(.easeInOut(duration: 1), value: phase)
                    
                    MarqueeView(text, font: marqueeFont)
                        .rotationEffect(.degrees(330))
                        .offset(y: phase == .transition ? -50 : 110)
                        .opacity(phase == .transition ? 0.3 : 1)
                        .animation(.easeInOut(duration: 1), value: phase)
                }
                
                
                // Center Section
                ZStack {
                    
                    HStack {
                        // Phase 1 → headline reveal
                        if !(phase == .showMonth) {
                            Text("WRAPPED ")
                                .foregroundStyle(.white)
                                .font(.custom("Viga", size: 45))
                        }
                        Text(currentText)
                            .multilineTextAlignment(.leading)
                            .font(.custom("Viga", size: 45))
                        
                        if !(phase == .showMonth) {
                            Text(" SHPE WRA")
                                .foregroundStyle(.white)
                            .font(.custom("Viga", size: 45)) }
                    }
                    
                    .foregroundStyle( phase == .showMonth ? Color(.white) : Color(orangeColor))
                    .transition(phase == .showMonth ? .asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ) : .identity)
                    .rotationEffect(.degrees(rotateToHorizontal ? 360 : -30))
                    .offset(y: showMonthDetails ? -100 : 0)
                    .fixedSize()
                    
                    
                    
                    
                    // Phase 2 → month reveal
                    if showMonthDetails {
                        VStack(spacing: 25) {
                            Text(vm.mostActiveMonth)
                                .font(.custom("Viga", size: 70))
                                .foregroundStyle(orangeColor)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                            
                            VStack(spacing: 4) {
                                Text("Followed Closely by:")
                                    .font(.custom("Viga", size: 20))
                                    .opacity(0.8)
                                
                                ForEach(vm.nextThreeMonths, id: \.self) { month in
                                    Text(month)
                                        .font(.custom("Viga", size: 15))
                                }
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                        .offset(y: 40)
                    }
                }
                .animation(.easeInOut(duration: 1), value: showMonthDetails)
                .animation(.easeInOut(duration: 1), value: phase)
                .frame(maxHeight: .infinity)
                
                
                // Bottom Marquees
                
                if phase != .showMonth {
                    MarqueeView(text, font: marqueeFont)
                        .rotationEffect(.degrees(330))
                        .offset(y: phase == .transition ? 50 : -110)
                        .opacity(phase == .transition ? 0.3 : 1)
                        .animation(.easeInOut(duration: 1), value: phase)
                    
                    MarqueeView(text, font: marqueeFont)
                        .rotationEffect(.degrees(330))
                        .offset(y: phase == .transition ? 10 : -220)
                        .opacity(phase == .transition ? 0.3 : 1)
                        .animation(.easeInOut(duration: 1), value: phase)
                }
                
                
                if phase == .intro {
                    Text("Tap To Begin")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                
            }
            .foregroundStyle(.white)
            .padding(.horizontal)
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .sensoryFeedback(.impact(flexibility: .solid, intensity: 0.5), trigger: alreadyViewed)
        // MARK: - Tap Sequence
        .onTapGesture {
            if (!alreadyViewed) {
                // Stage 1: Marquees fade out
                withAnimation(.easeInOut(duration: 1)) {
                    phase = .transition
                }
                
                // Stage 2: "Most Active Month" appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        rotateToHorizontal.toggle()
                        phase = .showMonth
                        currentText = "Most Active Month"
                    }
                }
                
                // Stage 3: Crossfade to "Month!" block
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        showMonthDetails = true
                    }
                }
                
                alreadyViewed = true
                vm.hasStarted = true
            }
        }
    }
}

#Preview {
    WrappedIntroView(vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:]))
}


import SwiftUI


