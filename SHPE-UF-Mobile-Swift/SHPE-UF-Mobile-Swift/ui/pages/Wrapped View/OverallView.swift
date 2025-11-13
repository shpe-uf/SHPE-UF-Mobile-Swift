//
//  YearsBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//

import SwiftUI

/// **YearsBannerView:** Swift wrapped popup
struct OverallView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm : OverallViewModel
    
    private var orange: Color {
        colorScheme == .dark
        ? Color(red: 253/255, green: 101/255, blue: 47/255)
        : Color(red: 211/255, green: 58/255, blue: 2/255)
    }
    
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)
            ZStack {
                VStack {
                    Text("You are a…")
                        .font(.custom("Viga", size: 36))
                        .fontWeight(.regular)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                    Text("Cabinet Enthusiast!")
                        .font(.custom("Viga", size: 48))
                        .fontWeight(.regular)
                        .foregroundColor(orange)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                }
                HStack {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showView = "OverallBannerView"
                        }
                    
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showView = "HomeView"
                        }
                }
                .zIndex(0)
                .edgesIgnoringSafeArea(.all)
            }
            .overlay(
                StoryIndicatorView(showView: $showView, currentIndex: 11)
                .padding(.top, 8)
                .zIndex(1),
                alignment: .top
                )
        
        }
        
    }
}
