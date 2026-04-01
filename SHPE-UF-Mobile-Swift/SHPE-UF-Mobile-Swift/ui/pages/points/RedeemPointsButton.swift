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
              .background(Color("orange_button"))
              .frame(width: 280, height: 50)
              .clipShape(.rect(cornerRadius: 16))
            Text("Redeem Code")
                .font(Font.custom("Viga-Regular", size: 20)).bold()
                .foregroundColor(.white)
                .frame(width: 372, height: 50, alignment: .center)
        }
    }
}

#Preview {
    RedeemPointsButton()
}
