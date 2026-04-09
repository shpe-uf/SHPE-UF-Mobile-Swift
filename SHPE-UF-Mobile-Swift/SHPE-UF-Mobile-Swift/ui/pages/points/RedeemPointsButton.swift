//  RedeemPointsButton.swift
//  UIDemo
//
//  Created by David Denis on 11/8/23.
//

import SwiftUI

/// A stylized button used to initiate the "Redeem Code" action.
///
/// `RedeemPointsButton` displays a rounded, orange button with the label
/// "Redeem Code". It is styled with custom dimensions and padding to match
/// the app's design language.
///
/// > Note: This view does **not** currently handle user interaction.
/// If interaction is needed, wrap this view inside a `Button { ... }`
/// or refactor it to accept an `action` closure.
///
/// ## Example:
/// ```swift
/// Button(action: {
///     // Handle code redemption
/// }) {
///     RedeemPointsButton()
/// }
/// ```
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
