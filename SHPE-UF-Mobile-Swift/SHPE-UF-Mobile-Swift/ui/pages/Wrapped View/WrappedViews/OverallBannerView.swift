import SwiftUI

struct OverallBannerView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: WrappedViewModel

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
                .ignoresSafeArea()

            VStack(spacing: -60) {

                // MARK: - Curved "Overall..." text
                ZStack {
                    let font = UIFont(name: "Viga", size: 72) ?? .systemFont(ofSize: 72)
                    let chars = Array(overallText)
                    let totalWidth = chars.reduce(0) {
                        $0 + charWidth(String($1), font: font)
                    }

                    let startCurveAngle = -110.0
                    let endCurveAngle = -77.0

                    var cumulativeWidth: CGFloat = 0
                    let angles: [(start: Double, end: Double)] = chars.map { ch in
                        let startAngle = startCurveAngle
                            + (cumulativeWidth / totalWidth)
                            * (endCurveAngle - startCurveAngle)

                        cumulativeWidth += charWidth(String(ch), font: font) * 1.2

                        let endAngle = startCurveAngle
                            + (cumulativeWidth / totalWidth)
                            * (endCurveAngle - startCurveAngle)

                        return (start: startAngle, end: endAngle)
                    }

                    ForEach(chars.indices, id: \.self) { i in
                        CurvedText(
                            text: String(chars[i]),
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

                // MARK: - "You are a..." typing line
                let characters = Array(secondText)

                HStack(spacing: 0) {
                    ForEach(characters.indices, id: \.self) { i in
                        Text(String(characters[i]))
                            .font(.custom("Viga", size: 36))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .opacity(secondCharCount > i ? 1 : 0)
                    }
                }
            }
        }
        .onAppear {
            resetAnimation()
            startTypingSequence()
        }
        .onDisappear {
            resetAnimation()
        }
    }

    // MARK: - Animation sequence (SwiftUI-native)

    private func startTypingSequence() {
        Task {
            // Animate curved "Overall..."
            for i in 0..<overallText.count {
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.easeInOut(duration: 0.6)) {
                    charCount = i + 1
                }
            }

            // Small pause before next line
            try? await Task.sleep(nanoseconds: 250_000_000)

            // Animate "You are a..."
            for i in 0..<secondText.count {
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.easeInOut(duration: 0.5)) {
                    secondCharCount = i + 1
                }
            }
        }
    }

    // MARK: - Reset

    private func resetAnimation() {
        charCount = 0
        secondCharCount = 0
    }

    // MARK: - Text width helper

    private func charWidth(_ char: String, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return char.size(withAttributes: attributes).width
    }
}

#Preview {
    OverallBannerView(
        vm: WrappedViewModel(
            SHPEito: SHPEito.mockSHPEito,
            categorizedEvents: [:]
        )
    )
}
