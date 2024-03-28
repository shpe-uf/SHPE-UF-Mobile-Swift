//
//  placeholderForLandingPageView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by test on 2/29/24.
//

import SwiftUI
struct placeholderForLandingPageView: View {
    @Environment(\.presentationMode) var isPresented
    @StateObject var viewModel: RegisterViewModel
    @State private var manualIndex = 0
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var isScrolling = false
    @State private var lastInteraction = Date()
    @State private var isRegisterViewPresented = false
    
    // list of images to display
    let images: [String] = ["carousel1", "carousel2", "carousel3", "carousel4", "carousel5", "carousel6", "carousel7", "carousel8"]
    
    // list of words to display
    let displayWords: [String] = ["Familia", "Leadership", "Professionalism", "Resilience", "Mentorship", "Education", "Technology", "Community"]
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                TabView(selection: $manualIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .resizable()
                            .scaledToFill()
                            .overlay(Color.black.opacity(0.4))
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .edgesIgnoringSafeArea(.all)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default page indicators
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 1)) {
                    if !isScrolling {
                            manualIndex = (manualIndex + 1) % images.count
                            
                            if manualIndex == 0 {
                                DispatchQueue.main.async {
                                    manualIndex = 0 // Reset to the first index
                                }
                            }
                        }
                    }
                }
                .transition(.move(edge: .leading))
                .onAppear {
                    timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
                }
                
                // Circles on the bottom
                HStack(spacing: 10) {
                    ForEach(images.indices, id: \.self) { index in
                        Circle()
                            .fill(index == manualIndex ? Color.white : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.bottom, 20)
                
                // Display logo
                Image("shpe_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.6)
                    .shadow(color: .black, radius: 1, x: 0, y: 0)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.3) // Adjust the y-coordinate here
                
                // Display "SHPE UF"
                Text("SHPE UF")
                    .font(.custom("Helvetica-Oblique", size: 48))
                    .italic()
                    .bold()
                    .shadow(color: .black, radius: 3, x: 0, y: 0)
                    .foregroundColor(.white)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                
                // Display alternating words
                Text(displayWords[manualIndex % displayWords.count]) // Alternate words from the display_words array
                    .font(.custom("PT Serif", size: 30))
                    .shadow(color: .black, radius: 3, x: 0, y: 0)
                    .foregroundColor(Color.lightGray)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.58)
                
                // Button to navigate to RegisterView
                Button(action: {
                    isRegisterViewPresented = true
                }) {
                    HStack {
                        Spacer() // Add spacer to push the text to the center
                        Text("Get Started")
                            .font(.custom("UniversLTStd", size: 25))
                            .foregroundColor(.white)
                        Spacer() // Add another spacer to push the text to the center
                    }
                }
                
                .frame(width: 290, height: 40)
                .padding()
                .foregroundColor(.white)
                .background(Color.dblue)
                .cornerRadius(10)
                .padding(.bottom, 50)
                .fullScreenCover(isPresented: $isRegisterViewPresented) {
                    RegisterView(viewModel: viewModel) // Assuming RegisterView takes viewModel as argument
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        isScrolling = true
                        pauseTimer()
                    }
                    .onEnded { _ in
                        startTimer()
                    }
            )
        }
        .edgesIgnoringSafeArea(.all)
    }
    // pause timer
    private func pauseTimer() {
        timer.upstream.connect().cancel()
        // resume timer after 3 seconds of inactivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            startTimer()
        }
    }
    // start timer
    private func startTimer() {
        isScrolling = false
        timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    }
}

struct placeholderForLandingPageView_Preview: PreviewProvider {
    static var previews: some View {
        placeholderForLandingPageView(viewModel: RegisterViewModel())
    }
}

