//
//  PostCarousel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/18/25.
//

import SwiftUI

struct PostCarousel: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    
    @ObservedObject var viewModel: InstagramViewModel
    
    var body: some View {
        
        
        VStack {
            ZStack {
                ForEach(viewModel.mockData.indices, id: \.self) { index in
                    let post = viewModel.mockData[index]
                    InstagramPostView(post: post)
                        .frame(width: 300, height: 500)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .opacity(currentIndex == index ? 1 : 0.3)
                        .scaleEffect(currentIndex == index ? 1.1 : 1)
                        .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset, y: 0)
                }
            }
            
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                currentIndex = min(viewModel.mockData.count - 1, currentIndex + 1)
                            }
                        }
                    }
            )
        }
    }
}

#Preview {
    PostCarousel(viewModel: InstagramViewModel())
}
