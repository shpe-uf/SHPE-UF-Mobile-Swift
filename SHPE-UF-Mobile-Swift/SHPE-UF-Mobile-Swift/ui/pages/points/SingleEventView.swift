//
//  SingleEventView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI

struct SingleEventView: View {
    
    var last: Bool = false
    
    var name: String = "Fall GBM\n6"
    var date: String = "11/08/2023"
    var points: Int = 1
    
    var body: some View {
        
        VStack(spacing: 0) {
        
            ZStack(alignment: .center) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 370, height: 75)
                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                
                
                HStack {
                    Text(name)
                        .font(Font.custom("Univers LT Std", size: 15))
                        .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                        .frame(width: 100, height: 50)
                        .padding(.trailing)
                    
                    
                    
                    Text(date)
                        .font(Font.custom("Univers LT Std", size: 15))
                        .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                        .frame(width: 100, height: 50)
                        .padding(.leading)
                       
                    
                    
                    
                    Text("\(points)")
                        .font(Font.custom("Univers LT Std", size: 15))
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

