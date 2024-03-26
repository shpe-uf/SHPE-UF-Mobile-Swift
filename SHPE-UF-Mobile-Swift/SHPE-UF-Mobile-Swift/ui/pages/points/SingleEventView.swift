//
//  SingleEventView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI

struct SingleEventView: View {
    var body: some View {
        
        ZStack(alignment: .center) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370, height: 100)
                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                .overlay(
                    
                    Rectangle()
                        .fill(Color(red: 0, green: 0.12, blue: 0.21))
                        .frame(width: 1, height: 100),
                    
                    
                    alignment: .trailing
                    
                )
                .overlay(
                    
                    Rectangle()
                        .fill(Color(red: 0, green: 0.12, blue: 0.21))
                        .frame(width: 1, height: 100),
                    
                    
                    alignment: .leading
                    
                )
                .overlay(
                    
                    Rectangle()
                        .fill(Color(red: 0, green: 0.12, blue: 0.21))
                        .frame(width: 370, height: 0.5),
                    
                    
                    alignment: .bottom
                    
                )
                .overlay(
                    
                    Rectangle()
                        .fill(Color(red: 0, green: 0.12, blue: 0.21))
                        .frame(width: 370, height: 0.5),
                    
                    
                    alignment: .top
                    
                )
            
            HStack {
                Text("Fall GBM\n6 ")
                    .font(Font.custom("Univers LT Std", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                    .frame(width: 100, height: 50)
                    .padding(.trailing)
                
               
                
                Text("11/08/2023")
                    .font(Font.custom("Univers LT Std", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                    .frame(width: 100, height: 50)
                    .padding(.leading)
                
                
                
                Text("1")
                    .font(Font.custom("Univers LT Std", size: 20))
                    .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                    .frame(width: 100, height: 50)
                    .padding(.leading)
                
            }
           
        }
    }
}

#Preview {
    SingleEventView()
}
