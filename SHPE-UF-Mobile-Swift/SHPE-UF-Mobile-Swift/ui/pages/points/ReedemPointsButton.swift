//
//  ReedemPointsButton.swift
//  UIDemo
//
//  Created by David Denis on 11/8/23.
//

import SwiftUI

struct ReedemPointsButton: View {
    
    var body: some View {
        
        
        ZStack {
            
            Rectangle()
            .foregroundColor(.clear)
            .frame(width: 797, height: 136)
            .background(Color(red: 0, green: 0.12, blue: 0.21))
            .cornerRadius(60)
            
            Text("Redeem Code")
                .foregroundStyle(.white)
                .font(Font.custom("Univers LT Std", size: 23))
                .bold()
        }
        .frame(width: 280, height: 45)
        .clipShape(.rect(cornerRadius: 20))
        
        
        
    }
}

#Preview {
    ReedemPointsButton()
}
