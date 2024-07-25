//  RedeemPointsButton.swift
//  UIDemo
//
//  Created by David Denis on 11/8/23.
//

import SwiftUI

struct RedeemPointsButton: View {
    
    var body: some View {
        
        
        ZStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 797, height: 136)
              .background(Color("orange_button"))
              .cornerRadius(60)
              .frame(width: 280, height: 50)
              .clipShape(.rect(cornerRadius: 22))
            Text("Redeem Code")
                .font(.system(size: 20)).bold()
                .foregroundColor(.white)
                .frame(width: 372, height: 50, alignment: .center)
        }
    }
}

#Preview {
    RedeemPointsButton()
}
