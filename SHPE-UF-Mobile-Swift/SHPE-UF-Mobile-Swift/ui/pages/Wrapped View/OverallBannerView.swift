import SwiftUI

struct OverallBannerView: View {
    @Binding var showView: String
    @Environment(\.colorScheme) var colorScheme
    @StateObject var vm: OverallViewModel
    
    @State private var dotCount: Int = 0
    
    var body: some View {
        ZStack {
            (colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: -60) {
                
                ZStack {
                    CurvedText(
                        text: "Overall",
                        radius: 400,
                        fontSize: 72,
                        textColor: Color(red: 114/255, green: 169/255, blue: 190/255),
                        startAngle: .degrees(-110),
                        endAngle: .degrees(-77),
                        rotation: 0
                    )
                    
                    CurvedText(
                        text: String(repeating: ".", count: dotCount),
                        radius: 400,
                        fontSize: 72,
                        textColor: Color(red: 114/255, green: 169/255, blue: 190/255),
                        startAngle: .degrees(-77),
                        endAngle: .degrees(-77 + Double(dotCount) * 2.5),
                        rotation: 0
                    )
                }
                .offset(y: 700)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            dotCount = (dotCount + 1) % 4
                        }
                    }
                }
                
                Text("You are a…")
                    .font(.custom("Viga", size: 36))
                    .fontWeight(.regular)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showView = "YearsView"
                    }
                
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showView = "OverallView"
                    }
            }
            .zIndex(0)
            .edgesIgnoringSafeArea(.all)
        }
        .overlay(
            StoryIndicatorView(showView: $showView, currentIndex: 10)
                .padding(.top, 8)
                .zIndex(1),
            alignment: .top
        )
    }
}
