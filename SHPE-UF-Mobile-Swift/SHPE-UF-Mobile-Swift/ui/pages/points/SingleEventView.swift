//
//  SingleEventView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI

struct SingleEventView: View {
    
    var last: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
        
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 370, height: 100)
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                
                
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
            
            Divider()
                .frame(width: 370, height: last ? 0 : 1)
                .overlay(.black)
                
           
        }
        
    }
}

#Preview {
    SingleEventView()
}

