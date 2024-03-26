//
//  CircularProgessView.swift
//  ProgressWheelDemo
//
//  Created by David Denis on 2/5/24.
//  Creates a progress wheel given a progress double
//

import SwiftUI

struct CircularProgessView: View {
   
    var progress: Double
    
    @State private var drawingStroke = false
    let animation = Animation
            .easeOut(duration: 3)
            .delay(0.5)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color(red: 0.6, green: 0.63, blue: 0.7), lineWidth: 60)
           
            Circle()
                .trim(from: 0, to: drawingStroke ? CGFloat(self.progress) : 0)
                .stroke(
                    Color(red: 0.04, green: 0.13, blue: 0.35),
                    style: StrokeStyle(lineWidth: 60, lineCap: .butt))
            
        }
        .rotationEffect(Angle(degrees: -90))
        .frame(width: 225, height: 225)
        .padding()
        .animation(.smooth(duration: 2.5), value: drawingStroke)
        .onAppear {
            drawingStroke.toggle()
    
        }
            
    }
}

#Preview {
    CircularProgessView(progress: 0.87)
}
