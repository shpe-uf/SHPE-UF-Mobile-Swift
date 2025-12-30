//
//  PointsPatternView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 12/22/25.
//

import SwiftUI

struct PointsPatternView: View {
    @Environment(\.colorScheme) var colorScheme
    let totalPoints: Int

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 5),
        count: 4
    )

    @State private var animate = false

    var body: some View {
        let text = "\(totalPoints)"

        ZStack {

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(0..<80, id: \.self) { index in
                        PointsCell(
                            text: text,
                            isOrange: index.isMultiple(of: 2),
                            animate: animate,
                            delay: Double(index % 8) * 0.08
                        )
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
            }
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
        .onAppear {
            resetAnimation()
        }
        .onDisappear {
            animate = false
        }
    }

    private func resetAnimation() {
        animate = false
        DispatchQueue.main.async {
            withAnimation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
            ) {
                animate = true
            }
        }
    }
}

private struct PointsCell: View {
    @Environment(\.colorScheme) var colorScheme
    let text: String
    let isOrange: Bool
    let animate: Bool
    let delay: Double

    var body: some View {
        Text(text)
            .font(.custom("Viga", size: 90, relativeTo: .largeTitle))
            .fontWeight(.bold)
            .foregroundColor(
                isOrange ? Color.profileOrange : colorScheme == .light ? Color.darkdarkBlue : Color.white
            )
            .lineLimit(1)
            .minimumScaleFactor(0.55)
            .frame(maxWidth: .infinity)
            .scaleEffect(animate ? 1.0 : 0.92)
            .opacity(animate ? 1.0 : 0.75)
            .animation(
                .easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
                .delay(delay),
                value: animate
            )
    }
}

#Preview {
    PointsPatternView(totalPoints: 21)
        .preferredColorScheme(.dark)
}
