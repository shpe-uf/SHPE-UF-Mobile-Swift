//
//  CategoryBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 11/5/25.
//

import SwiftUI

struct CategoryBannerView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: YearsViewModel
    
    private var color1: Color {
        colorScheme == .dark
        ? Color(red: 114/255, green: 169/255, blue: 190/255)
        : Color(red: 211/255, green: 58/255, blue: 2/255)
    }

    private var color2: Color {
        colorScheme == .dark
        ? Color(red: 253/255, green: 101/255, blue: 47/255)
        : Color(red: 0/255, green: 112/255, blue: 192/255)
    }
    
    @State private var title1 = "Your Top Category"
    @State private var title2 = " of the Year is..."
    
    private func coloredCharacters(for text: String, startingIndex: Int = 0) -> [(Character, Color)] {
            var result: [(Character, Color)] = []
            var nonSpaceIndex = startingIndex

            for char in text {
                let color = nonSpaceIndex % 2 == 0 ? color1 : color2
                result.append((char, color))
                if char != " " {
                    nonSpaceIndex += 1
                }
            }
            return result
        }

    
    var body: some View {
        
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack(spacing: 10) {
                Spacer()
                VStack(spacing: 10) {
                    HStack(spacing: 0) {
                        let chars = coloredCharacters(for: title1)
                        ForEach(Array(chars.enumerated()), id: \.offset) { _, item in
                            let (char, color) = item
                            Text(String(char))
                                .font(.custom("Viga", size: 36))
                                .foregroundColor(color)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        let offset = coloredCharacters(for: title1).filter { $0.0 != " " }.count
                        let chars = coloredCharacters(for: title2, startingIndex: offset)
                        ForEach(Array(chars.enumerated()), id: \.offset) { _, item in
                            let (char, color) = item
                            Text(String(char))
                                .font(.custom("Viga", size: 36))
                                .foregroundColor(color)
                        }
                    }
                }
                .multilineTextAlignment(.center)
                
                Spacer()
            }
            
            HStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { showView = "WrappedView" }
            
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { showView = "CategoryView" }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(
            StoryIndicatorView(showView: $showView, currentIndex: 6)
            .padding(.top, 8)
            .zIndex(1),
            alignment: .top
            )
    }
}

