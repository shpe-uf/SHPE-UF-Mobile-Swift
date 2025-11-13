import SwiftUI

struct OverallBannerView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: OverallViewModel

    @State private var charCount: Int = 0
    @State private var secondCharCount: Int = 0
    private let overallText = "Overall..."
    private let secondText = "You are a..."
    
    private var blue: Color {
        colorScheme == .dark
        ? Color(red: 114/255, green: 169/255, blue: 190/255)
        : Color(red: 0/255, green: 112/255, blue: 192/255)
    }

    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: -60) {
                // Overall curved text
                ZStack {
                    let font = UIFont(name: "Viga", size: 72) ?? .systemFont(ofSize: 72)
                    let chars = Array(overallText)
                    let totalWidth = chars.reduce(0) { $0 + charWidth(String($1), font: font) }
                    let startCurveAngle = -110.0
                    let endCurveAngle = -77.0

                    var cumulativeWidth: CGFloat = 0
                    let angles: [(start: Double, end: Double)] = chars.map { ch in
                        let startAngle = startCurveAngle + (cumulativeWidth / totalWidth) * (endCurveAngle - startCurveAngle)
                        cumulativeWidth += charWidth(String(ch), font: font) * 1.2
                        let endAngle = startCurveAngle + (cumulativeWidth / totalWidth) * (endCurveAngle - startCurveAngle)
                        return (start: startAngle, end: endAngle)
                    }

                    ForEach(0..<chars.count, id: \.self) { i in
                        let index = overallText.index(overallText.startIndex, offsetBy: i)
                        CurvedText(
                            text: String(overallText[index]),
                            radius: 400,
                            fontSize: 72,
                            textColor: blue.opacity(charCount > i ? 1 : 0),
                            startAngle: .degrees(angles[i].start),
                            endAngle: .degrees(angles[i].end),
                            rotation: 0
                        )
                    }
                }
                .offset(y: 700)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true) { timer in
                        withAnimation(.easeInOut(duration: 1)) {
                            charCount += 1
                        }
                        if charCount >= overallText.count {
                            timer.invalidate()
                            animateSecondText()
                        }
                    }
                }

                HStack(spacing: 0) {
                    ForEach(0..<secondText.count, id: \.self) { i in
                        let index = secondText.index(secondText.startIndex, offsetBy: i)
                        Text(String(secondText[index]))
                            .font(.custom("Viga", size: 36))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .opacity(secondCharCount > i ? 1 : 0)
                    }
                }
            }

            HStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { showView = "YearsView" }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { showView = "OverallView" }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .overlay(
            StoryIndicatorView(showView: $showView, currentIndex: 10)
                .padding(.top, 8),
            alignment: .top
        )
    }

    private func animateSecondText() {
        Timer.scheduledTimer(withTimeInterval: 0.10, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 1)) {
                secondCharCount += 1
            }
            if secondCharCount >= secondText.count {
                timer.invalidate()
            }
        }
    }

    private func charWidth(_ char: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return char.size(withAttributes: attributes).width
    }
}
