//
//  PointsUI.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 11/9/23.
//

import SwiftUI

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
                    .font(Font.custom("Univers LT Std", size: 20)).bold().monospaced()
                    .frame(width: 100)
                    .padding()
                
                
                Divider()
                    .frame(width: 1)
                    .overlay(.white)
                    .padding(.vertical)
                    
                    
                
                Text(String(points))
                    .foregroundStyle(.white)
                    .font(Font.custom("Univers LT Std", size: 20)).bold().monospaced()
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
