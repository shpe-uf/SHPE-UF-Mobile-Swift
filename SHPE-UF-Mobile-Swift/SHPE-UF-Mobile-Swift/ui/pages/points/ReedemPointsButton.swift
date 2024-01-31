//
//  ReedemPointsButton.swift
//  UIDemo
//
//  Created by David Denis on 11/8/23.
//

import SwiftUI

struct ReedemPointsButton: View {
    
    var body: some View {
        
        
        HStack {
            
            HStack {
                Image(systemName: "plus")
                    .font(.title2).bold().fontDesign(.monospaced)
            }
            .frame(width: 30, height: 50)
            .padding(.leading)
            .background(.linearGradient(colors: [.rblue, .rorange], startPoint: .top, endPoint: .bottom))
            
            
            HStack {
                Text("Redeem Code")
                    .font(.title2).bold().fontDesign(.monospaced)
                    .foregroundStyle(.primary)
            }
            .frame(width: 250, height: 50)
            .background(.linearGradient(colors: [.rblue, .rorange], startPoint: .top, endPoint: .bottom))
        }
        .frame(width: 280, height: 50)
        .clipShape(.rect(cornerRadius: 10))
        
        
        
    }
}

#Preview {
    ReedemPointsButton()
}
