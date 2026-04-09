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
    
    @Binding var isShowingList : Bool
    
    var body: some View {
        
        if #available(iOS 26.0, *) {
            Button {
                isShowingList = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.tint)
                        .fill(gradient)
                    
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
                
            }
            .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: 25))
            .padding(.horizontal)
            .padding(.vertical, 2)
            
        } else {
            Button {
                isShowingList = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.tint)
                        .fill( gradient)
                    
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
            }
        }
    }
}

extension View {
    @ViewBuilder
    func ifiOS26<Content: View>(
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        if #available(iOS 26.0, *) {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    PointsUI(points: 14, semester: "Fall", percent: 99, gradient: LinearGradient(colors: [.black, .blue], startPoint: .bottom, endPoint: .top), isShowingList: .constant(false))
        .preferredColorScheme(.dark)

}
