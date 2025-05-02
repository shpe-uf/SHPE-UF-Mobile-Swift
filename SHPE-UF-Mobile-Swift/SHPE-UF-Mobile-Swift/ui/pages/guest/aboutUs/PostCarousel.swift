//
//  PostCarousel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/18/25.
//
import SwiftUI

struct PostCarousel: View {
    @State private var currentIndex = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var showHint = true
    @ObservedObject var viewModel: InstagramViewModel
    @Environment(\.horizontalSizeClass) private var hSize
    
    var body: some View {

        // ───────── REGULAR WIDTH (iPad) ─────────
        if hSize == .regular {
            TabView(selection: $currentIndex) {
                ForEach(viewModel.mockData.indices, id: \.self) { idx in
                    InstagramPostView(post: viewModel.mockData[idx])
                        .tag(idx)
                        .frame(width: 400, height: 550)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal, 40)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))   // hide default dots
            .frame(height: 560)
            .overlay(alignment: .bottom) {
                PageIndicatorBar(total: viewModel.mockData.count, current: currentIndex)
                    .padding(.top, 100)  // Pushes it down from the top
                    .animation(.easeInOut, value: currentIndex)
            }

        // ───────── COMPACT WIDTH (iPhone) ─────────
        } else {
            originalCarouselBody
        }
    }

    // Extract your existing VStack-&-ZStack so we can call it here
    private var originalCarouselBody: some View {
        VStack {
            ZStack {
                ForEach(viewModel.mockData.indices, id: \.self) { index in
                    let post = viewModel.mockData[index]
                    InstagramPostView(post: post)
                        .frame(width: 300, height: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .opacity(currentIndex == index ? 1 : 0.3)
                        .scaleEffect(currentIndex == index ? 1.1 : 1)
                        .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset)
                }
            }
            .gesture(dragGesture)
        }
    }

    // Your existing drag logic factored out so both bodies can share it
    private var dragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                let threshold: CGFloat = 50
                if value.translation.width > threshold {
                    withAnimation { currentIndex = max(0, currentIndex - 1) }
                } else if value.translation.width < -threshold {
                    withAnimation { currentIndex = min(viewModel.mockData.count - 1,
                                                       currentIndex + 1) }
                }
            }
    }
}



private struct PageIndicatorBar: View {
    let total: Int        // total number of posts
    let current: Int      // zero-based current index

    // Dot sizes
    private let normalSize: CGFloat = 10
    private let smallSize:  CGFloat = 7
    private let tinySize:   CGFloat = 4
    private let spacing:    CGFloat = 12

    // Intensity falloff: 3 = center, 2 = adjacent, etc.
    private func generateDotArray() -> [Int] {
        var array = Array(repeating: 0, count: total)
        let maxValue = 3

        for offset in -maxValue...maxValue {
            let index = current + offset
            if index >= 0 && index < total {
                array[index] = maxValue - abs(offset)
            }
        }

        return array
    }

    // Convert dot level (3, 2, 1, 0) to sizes
    private func sizeForLevel(_ level: Int) -> CGFloat? {
        switch level {
        case 3: return normalSize
        case 2: return smallSize
        case 1: return tinySize
        default: return nil  // hide or skip
        }
    }

    var body: some View {
        let dotLevels = generateDotArray()

        HStack(spacing: spacing) {
            ForEach(0..<dotLevels.count, id: \.self) { i in
                if let size = sizeForLevel(dotLevels[i]) {
                    Circle()
                        .frame(width: size, height: size)
                        .foregroundColor(i == current ? .profileOrange : .gray)
                        .transition(.scale)
                }
            }
        }
        .animation(.easeInOut, value: current)
    }
}



#Preview {
    PostCarousel(viewModel: InstagramViewModel())
}
