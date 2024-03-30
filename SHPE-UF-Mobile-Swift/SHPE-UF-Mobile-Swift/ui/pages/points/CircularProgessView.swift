//
//  CircularProgessView.swift
//  ProgressWheelDemo
//
//  Created by David Denis on 2/5/24.
//  Creates a progress wheel given a progress double
//

import SwiftUI

struct CircularProgessView: View {
    
    @StateObject var vm:PointsViewModel
    var progress: Double
    
    @State private var drawingStroke = false
    
    let animation = Animation
        .easeOut(duration: 3)
        .delay(0.5)
    
    var body: some View {
        ZStack {
            
            Circle()
                .stroke(Color(red: 0.6, green: 0.63, blue: 0.7), lineWidth: 70)
            
            
            Circle()
                .trim(from: 0, to: vm.doAnimation ? CGFloat(self.progress) : 0)
                .stroke(
                    LinearGradient(gradient: Gradient(colors: [Color.bottomBlue, Color.topBlue]), startPoint: .leading, endPoint: .trailing),
                    style: StrokeStyle(lineWidth: 70, lineCap: .butt))
            
        }
        .rotationEffect(Angle(degrees: -90))
        .frame(width: 250, height: 250)
        .padding()
        .animation(animation, value: drawingStroke)
        .onAppear {
            self.drawingStroke = true
        }
        
    }
}

//#Preview {
//    CircularProgessView(progress: 0.87)
//}
