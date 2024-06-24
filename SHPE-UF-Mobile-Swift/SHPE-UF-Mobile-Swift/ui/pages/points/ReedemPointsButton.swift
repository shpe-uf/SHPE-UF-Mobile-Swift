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
              .cornerRadius(25)
              .frame(width: 280, height: 50)
            .clipShape(.rect(cornerRadius: 22))
            Text("Reedem Code")
                .font(Font.custom("Univers LT Std 65 Bold", size: 25))
              .foregroundColor(.white)
              .frame(width: 372, height: 50, alignment: .center)
        }
    }
}

#Preview {
    ReedemPointsButton()
}
