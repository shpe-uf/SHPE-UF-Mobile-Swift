//
//  WrappedView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 9/17/25.
//

import SwiftUI

/// **WrappedView:** Swift wrapped popup
struct WrappedView: View {
    @Binding var showView: AppRoute
    @Environment(\.colorScheme) var colorScheme
    
    let wrappedLine = String(repeating: "SHPE Wrapped ", count: 10)
    let wrappedLine2 = "     " + String(repeating: "SHPE Wrapped ", count: 10)
    let wrappedLine3 = "          " + String(repeating: "SHPE Wrapped ", count: 10)
    let wrappedLine4 = "               " + String(repeating: "SHPE Wrapped ", count: 10)
    
    var body: some View {
        VStack(spacing: 10) {
            Image("shpe_logo")
                .resizable()
                .frame(width: 49, height: 49)
            ZStack {
                Constants.orange
                    .frame(width: 300, height: 386)
                    .cornerRadius(16)
                VStack{
                    Text(wrappedLine)
                        .wrappedText()
                    
                    Text(wrappedLine2)
                        .wrappedText()
                    
                    Text(wrappedLine3)
                        .wrappedText()
                    
                    Text(wrappedLine4)
                        .wrappedText()
                    
                    HStack{
                        Text("SHPE Wrapped")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                        
                    }
                    Text(wrappedLine2)
                        .wrappedText()
                    
                    Text(wrappedLine3)
                        .wrappedText()
                    
                    Text(wrappedLine4)
                        .wrappedText()
                    
                    HStack{
                        Text("d")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                    }
                    Text(wrappedLine2)
                        .wrappedText()
                    
                    Text(wrappedLine3)
                        .wrappedText()
                    
                    HStack{
                        Text("ed")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                        
                        Text("SHPE Wrapped")
                            .wrappedText()
                    }
                    Text(wrappedLine4)
                        .wrappedText()
                    
                    Text(wrappedLine2)
                        .wrappedText()
                    
                    Text(wrappedLine3)
                        .wrappedText()
                    
                    Text(wrappedLine4)
                        .wrappedText()
                    
                }
                    .frame(width: 570, height: 490)
                    .rotationEffect(.degrees(-20))
                    .mask(
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 300, height: 386)
                    )
                VStack {
                    
                    Text("Your SHPE Wrapped is here.")
                        .foregroundColor(.white)
                        .font(Font.custom("Viga", size: 44))
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 233)
                    
                    Button {
                        withAnimation(.linear) {
                            showView = .wrapped(.intro)
                        }
                        
                    } label: {
                        Text("LET'S GO!")
                            .font(Font.custom("Univers-LT-Std", size: 16))
                            .frame(width: 171)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.bottomBlue)
                            .cornerRadius(8)
                    }
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 3)
                    .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: showView)
                    
                    Button {
                        showView = .home
                    } label: {
                        Text("Maybe later")
                            .frame(height: 30)
                            .font(Font.custom("Inter", size: 12))
                            .foregroundColor(.white)
                            .underline()
                    }
                }
                .padding(.horizontal, 20)
            }
            .backgroundStyle(.red)
                
            }
            .offset(y: -30)
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
    }

}

/// Extension on Text to not have repetitive modifiers
extension Text {
    func wrappedText() -> some View {
        self
            .font(Font.custom("Viga", size: 25))
            .foregroundColor(.white.opacity(0.30))
            .lineLimit(1)
    }
}

#Preview {
    WrappedView(showView: .constant(.home))
}



