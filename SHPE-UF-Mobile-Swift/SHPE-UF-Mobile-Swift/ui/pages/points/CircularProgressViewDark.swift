//
//  CircularProgessView.swift
//  ProgressWheelDemo
//
//  Created by David Denis on 2/5/24.
//  Creates a progress wheel given a progress double
//

import SwiftUI

struct CircularProgessViewDark: View {
   
    var progress: Double
    
    
    @State private var drawingStroke = false
    let animation = Animation
            .easeOut(duration: 3)
            .delay(0.5)
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color(red: 0.49, green: 0.51, blue: 0.56), lineWidth: 70)
           
            Circle()
                .trim(from: 0, to: drawingStroke ? CGFloat(self.progress) : 0)
                .stroke(
                    LinearGradient(
                    stops: [
                    Gradient.Stop(color: Color(red: 0.04, green: 0.13, blue: 0.35), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.18, green: 0.38, blue: 0.62), location: 0.98),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                    ),
                    style: StrokeStyle(lineWidth: 70, lineCap: .butt))
            
        }
        .rotationEffect(Angle(degrees: -90))
        .frame(width: 250, height: 250)
        .padding()
        .animation(.smooth(duration: 2.5), value: drawingStroke)
        .onAppear {
            // Reset the animation state
            self.drawingStroke = false
            
            // Slight delay to ensure the animation can restart smoothly
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.drawingStroke = true
            }
        }
            
    }
}

#Preview {
    CircularProgessViewDark(progress: 0.87)
}
