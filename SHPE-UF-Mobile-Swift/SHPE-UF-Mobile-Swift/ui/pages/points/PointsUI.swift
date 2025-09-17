//
//  PointsUI.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 11/9/23.
//

import SwiftUI

/// A styled card displaying points information for a specific semester.
///
/// This component:
/// 1. Shows semester name, percentile ranking, and points
/// 2. Uses a customizable gradient background
/// 3. Provides consistent formatting for all point displays
///
/// ## Visual Features
/// - Gradient background with material overlay
/// - Clean monospaced typography
/// - Vertical dividers between sections
/// - Rounded corners
///
/// ## Example Usage
/// ```swift
/// PointsUI(
///     points: 1250,
///     semester: "Fall",
///     percent: 15,
///     gradient: fallGradient
/// )
/// ```
struct PointsUI: View {
    
    var points: Int
    var semester: String
    var percent: Int
    
    var gradient: LinearGradient
    
    var body: some View {
        
        ZStack {
            
           gradient
            
            HStack {
                Text(semester.uppercased())
                    .foregroundStyle(.white)
                    .font(.title2).bold().fontDesign(.monospaced)
                    .frame(width: 85)
                    

        
                Divider()
                    .frame(width: 1)
                    .overlay(.white)
                    .padding(.vertical)
                
                
                
                Text("TOP \(percent)%")
                    .foregroundStyle(.white)
                    .font(.title2).bold().fontDesign(.monospaced)
                    .frame(width: 100)
                    .padding()
                
                
                Divider()
                    .frame(width: 1)
                    .overlay(.white)
                    .padding(.vertical)
                    
                    
                
                Text(String(points))
                    .foregroundStyle(.white)
                    .font(.title2).bold().fontDesign(.monospaced)
                    .frame(width: 60)
                
            }

            
        }
        .frame(width: 320, height: 75)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
  
    }
}

#Preview {
    PointsUI(points: 14, semester: "Fall", percent: 99, gradient: LinearGradient(colors: [.black, .blue], startPoint: .bottom, endPoint: .top))
    
    
}
