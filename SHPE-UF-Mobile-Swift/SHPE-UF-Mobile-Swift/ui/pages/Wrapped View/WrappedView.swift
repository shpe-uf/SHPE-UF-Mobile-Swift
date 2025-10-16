//
//  WrappedView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Alex Milanes on 9/17/25.
//

import SwiftUI

/// **WrappedView:** Swift wrapped popup
struct WrappedView: View {
    @Binding var showView: String
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
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine2)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine3)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine4)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    HStack{
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.black.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                    }
                    Text(wrappedLine2)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine3)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine4)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    HStack{
                        Text("d")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.black.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                    }
                    Text(wrappedLine2)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine3)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    HStack{
                        Text("ed")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.black.opacity(0.30))
                            .lineLimit(1)
                        Text("SHPE Wrapped")
                            .font(Font.custom("Viga", size: 25))
                            .foregroundColor(.white.opacity(0.30))
                            .lineLimit(1)
                    }
                    Text(wrappedLine4)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine2)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine3)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
                    Text(wrappedLine4)
                        .font(Font.custom("Viga", size: 25))
                        .foregroundColor(.white.opacity(0.30))
                        .lineLimit(1)
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
                        showView = "YearsBannerView"
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
                    
                    Button {
                        showView = "HomeView"
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
