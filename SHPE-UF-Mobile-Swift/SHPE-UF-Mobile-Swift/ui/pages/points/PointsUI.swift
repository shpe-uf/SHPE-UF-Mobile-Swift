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
    
    var body: some View {
        
        ZStack {
            
            //LinearGradient(colors: [.rblue, .lblue], startPoint: .top, endPoint: .bottom)
            
            LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
            LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .topLeading, endPoint: .bottom)
            
            HStack {
                Text(semester.uppercased())
                    .foregroundStyle(.foreground)
                    .font(.title2).bold().fontDesign(.monospaced)
                    .frame(width: 90)
                    

        
                Divider()
                    .frame(width: 1)
                    .overlay(.black)
                    .padding(.vertical)
                
                
                
                Text("TOP \(percent) PERCENT")
                    .foregroundStyle(.white)
                    .font(.title2).bold().fontDesign(.monospaced)
                    .frame(width: 100)
                    .padding()
                
                
                Divider()
                    .frame(width: 1)
                    .overlay(.black)
                    .padding(.vertical)
                    
                    
                
                Text(String(points))
                    .foregroundStyle(.white)
                    .font(.title2).bold().fontDesign(.monospaced)
                    .frame(width: 60)
                
            }

            
        }
        .frame(width: 350, height: 100)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
  
    }
}

#Preview {
    PointsUI(points: 14, semester: "Fall", percent: 99)
    
}
