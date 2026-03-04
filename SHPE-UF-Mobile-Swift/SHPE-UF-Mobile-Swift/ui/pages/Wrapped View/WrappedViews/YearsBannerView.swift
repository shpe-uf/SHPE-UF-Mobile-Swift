//
//  YearsBannerView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes
//

import SwiftUI

// MARK: - CurvedText

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
            ForEach(charData.indices, id: \.self) { i in
                let (char, angle) = charData[i]
                Text(char)
                    .font(.custom("Viga", size: fontSize))
                    .foregroundColor(textColor)
                    .rotationEffect(.radians(angle + .pi / 2 + rotation))
                    .offset(
                        x: radius * cos(angle),
                        y: radius * sin(angle) - radius
                    )
            }
        }
    }

    private func charWidth(_ char: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return char.size(withAttributes: attributes).width
    }
}

// MARK: - YearsBannerView

struct YearsBannerView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: WrappedViewModel

    @State private var appeared = false

    private var orange: Color {
        colorScheme == .dark
        ? Color(red: 253/255, green: 101/255, blue: 47/255)
        : Color(red: 211/255, green: 58/255, blue: 2/255)
    }

    private var blue: Color {
        colorScheme == .dark
        ? Color(red: 114/255, green: 169/255, blue: 190/255)
        : Color(red: 0/255, green: 112/255, blue: 192/255)
    }
    
    private let colorCycle: [Color] = [
        .white,
        Color(red: 114/255, green: 169/255, blue: 190/255), // blue
        Color(red: 253/255, green: 101/255, blue: 47/255)   // orange
    ]

    var body: some View {
        let text = vm.yearsInSHPE == 1 ? "1 YEAR" : "\(vm.yearsInSHPE) YEARS"
        let fontSize = CGFloat(vm.yearsInSHPE == 1 ? 105 : 96)

        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .ignoresSafeArea()

            TimelineView(.periodic(from: .now, by: 0.8)) { context in
                let step = Int(context.date.timeIntervalSinceReferenceDate / 0.8)

                VStack(spacing: -30) {
                    ForEach(0..<5, id: \.self) { i in
                        CurvedText(
                            text: text,
                            radius: 485,
                            fontSize: fontSize,
                            textColor: cycledColor(step: step, ringIndex: i),
                            startAngle: .degrees(113),
                            endAngle: .degrees(67),
                            rotation: .pi
                        )
                        .opacity(i == 2 ? 1.0 : 0.9)
                        .shadow(color: .black.opacity(i == 2 ? 0.25 : 0.15), radius: i == 2 ? 14 : 8)
                    }
                }
            }
            .scaleEffect(appeared ? 1 : 0.85)
            .opacity(appeared ? 1 : 0)
            .rotationEffect(.degrees(appeared ? 0 : -8))
            .animation(
                .spring(response: 0.9, dampingFraction: 0.8),
                value: appeared
            )
        }
        .onAppear {
            appeared = true
        }
    }
    
    private func cycledColor(step: Int, ringIndex: Int) -> Color {
        // Offset each ring so they don't all flip at the same time
        let offset = ringIndex

        // Cycle through [white, blue, orange]
        let idx = (step + offset) % colorCycle.count
        return colorCycle[idx]
    }

}

// MARK: - Preview

#Preview {
    YearsBannerView(vm: WrappedViewModel(SHPEito: SHPEito.mockSHPEito, categorizedEvents: [:]))
    .preferredColorScheme(.dark)
}
