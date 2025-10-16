//
//  YearsBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 10/2/25.
//

import SwiftUI

struct CurvedText: View {
    let text: String
    let radius: CGFloat
    let fontSize: CGFloat
    let textColor: Color
    let startAngle: Angle
    let endAngle: Angle
    let rotation: Double

    var body: some View {
        let font = UIFont(name: "Viga", size: fontSize) ?? .systemFont(ofSize: fontSize)
        let chars = Array(text)
        let totalWidth = chars.reduce(0) { $0 + charWidth(String($1), font: font) }
        let start = startAngle.radians
        let end = endAngle.radians
        let span = end - start

        var cumulativeWidth: CGFloat = 0
        let charData = chars.map { ch -> (char: String, angle: Double) in
            let char = String(ch)
            let width = charWidth(char, font: font)
            let center = cumulativeWidth + width / 2
            cumulativeWidth += width
            let angle = start + (center / totalWidth) * span
            return (char, angle)
        }

        return ZStack {
            ForEach(0..<charData.count, id: \.self) { i in
                let (char, angle) = charData[i]
                Text(char)
                    .font(.custom("Viga", size: fontSize))
                    .foregroundColor(textColor)
                    .rotationEffect(.radians(angle + .pi / 2 + rotation))
                    .offset(x: radius * cos(angle),
                            y: radius * sin(angle) - radius)
            }
        }
    }

    private func charWidth(_ char: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return char.size(withAttributes: attributes).width
    }
}


struct YearsBannerView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: YearsViewModel
    
    @State private var colorSwapped: Bool = false
    
    var body: some View {
        let fontSize = CGFloat(vm.numYears == 1 ? 105 : 96)
        
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: -30) {
                ForEach(0..<5, id: \.self) { i in
                    if i == 2 {
                        CurvedText(
                            text: vm.numYears == 1 ? "1 YEAR" : "\(vm.numYears) YEARS",
                            radius: 485,
                            fontSize: fontSize,
                            textColor: colorScheme == .dark ? .white : .black,
                            startAngle: .degrees(113),
                            endAngle: .degrees(67),
                            rotation: .pi
                        )
                    } else {
                        if colorSwapped {
                            CurvedText(
                                text: vm.numYears == 1 ? "1 YEAR" : "\(vm.numYears) YEARS",
                                radius: 485,
                                fontSize: fontSize,
                                textColor: Color(red: 114/255, green: 169/255, blue: 190/255),
                                startAngle: .degrees(113),
                                endAngle: .degrees(67),
                                rotation: .pi
                            )
                            CurvedText(
                                text: vm.numYears == 1 ? "1 YEAR" : "\(vm.numYears) YEARS",
                                radius: 485,
                                fontSize: fontSize,
                                textColor: Color(red: 253/255, green: 101/255, blue: 47/255),
                                startAngle: .degrees(113),
                                endAngle: .degrees(67),
                                rotation: .pi
                            )
                        } else {
                            CurvedText(
                                text: vm.numYears == 1 ? "1 YEAR" : "\(vm.numYears) YEARS",
                                radius: 485,
                                fontSize: fontSize,
                                textColor: Color(red: 253/255, green: 101/255, blue: 47/255),
                                startAngle: .degrees(113),
                                endAngle: .degrees(67),
                                rotation: .pi
                            )
                            CurvedText(
                                text: vm.numYears == 1 ? "1 YEAR" : "\(vm.numYears) YEARS",
                                radius: 485,
                                fontSize: fontSize,
                                textColor: Color(red: 114/255, green: 169/255, blue: 190/255),
                                startAngle: .degrees(113),
                                endAngle: .degrees(67),
                                rotation: .pi
                            )
                        }
                    }
                }
            }
            
            HStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { showView = "WrappedView" }
            
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { showView = "YearsView" }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(
            StoryIndicatorView(showView: $showView, currentIndex: 8)
                .padding(.top, 135),
            alignment: .top
        )
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                withAnimation(.none) {
                    colorSwapped = !colorSwapped
                }
            }
        }
    }
}

