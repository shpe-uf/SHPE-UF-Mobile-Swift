//
//  CategoryBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 11/5/25.
//

import SwiftUI

struct CategoryBannerView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: WrappedViewModel

    @State private var showLine1 = false
    @State private var showLine2 = false

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
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 10) {

                    // MARK: - Line 1
                    HStack(spacing: 0) {
                        let chars = coloredCharacters(for: title1)
                        ForEach(Array(chars.enumerated()), id: \.offset) { index, item in
                            let (char, color) = item
                            Text(String(char))
                                .font(.custom("Viga", size: 36, relativeTo: .title))
                                .foregroundColor(color)
                                .opacity(showLine1 ? 1 : 0)
                                .offset(y: showLine1 ? 0 : 12)
                                .animation(
                                    .easeOut(duration: 0.35)
                                    .delay(Double(index) * 0.03),
                                    value: showLine1
                                )
                        }
                    }

                    // MARK: - Line 2
                    HStack(spacing: 0) {
                        let offset = coloredCharacters(for: title1)
                            .filter { $0.0 != " " }.count
                        let chars = coloredCharacters(for: title2, startingIndex: offset)

                        ForEach(Array(chars.enumerated()), id: \.offset) { index, item in
                            let (char, color) = item
                            Text(String(char))
                                .font(.custom("Viga", size: 36, relativeTo: .title))
                                .foregroundColor(color)
                                .opacity(showLine2 ? 1 : 0)
                                .offset(y: showLine2 ? 0 : 12)
                                .animation(
                                    .easeOut(duration: 0.35)
                                    .delay(Double(index) * 0.04),
                                    value: showLine2
                                )
                        }
                    }
                }
                .multilineTextAlignment(.center)

                Spacer()
            }
        }
        .onAppear {
            showLine1 = false
            showLine2 = false

            // Line 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                showLine1 = true
            }

            // Line 2
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                showLine2 = true
            }
        }
    }
    
    private func coloredCharacters(
        for text: String,
        startingIndex: Int = 0
    ) -> [(Character, Color)] {
        var result: [(Character, Color)] = []
        var nonSpaceIndex = startingIndex

        for char in text {
            let color = nonSpaceIndex % 2 == 0 ? color1 : color2
            result.append((char, color))
            if char != " " { nonSpaceIndex += 1 }
        }
        return result
    }
}

#Preview {
    CategoryBannerView(vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:])
    )
}
