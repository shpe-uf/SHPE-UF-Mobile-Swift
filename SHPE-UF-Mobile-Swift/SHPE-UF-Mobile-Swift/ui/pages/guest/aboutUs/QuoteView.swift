//
//  QuoteView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/19/25.
//

import SwiftUI

struct QuoteView: View {
    var body: some View {
        ZStack {
            // Background with cut-out effect
            CutoutBackground()
                .fill(Color(.profileOrange)) // Use your desired color
                
            
            // Text Content
            VStack(spacing: 20) {
                Text("“What I really hope for young people is that they find a career they’re passionate about, something that’s challenging and worthwhile.”")
                    .font(Font.custom("Viga-Regular", size: 25))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                
                VStack {
                    Text("Ellen Ochoa")
                        .font(Font.custom("Viga-Regular", size: 23))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom)
                    
                    Text("Electrical Engineer\n& First Latina Astronaut")
                        .font(Font.custom("Viga-Regular", size: 17))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        
                }
                .frame(height: UIScreen.main.bounds.height * 0.15)
            }
            .padding(.top, 60)
            
            
        }
        

    }
}

// GPT
// Custom shape to create the cut-out effect
struct CutoutBackground: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at top-left
        path.move(to: .zero)
        // Top edge until cutout
        path.addLine(to: CGPoint(x: rect.midX - 20, y: 0))
        // Cutout triangle
        path.addLine(to: CGPoint(x: rect.midX, y: 30))
        path.addLine(to: CGPoint(x: rect.midX + 20, y: 0))
        // Continue to top-right
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        // Down to bottom-right
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        // Bottom-left
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        // Close path
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    QuoteView()
}
