//
//  AboutUsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/17/25.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        
        VStack {
            
            /// NAV BAR
            ZStack(alignment: .bottom) {
                
                Rectangle()
                    .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                    .frame(width: UIScreen.main.bounds.width, height: 100)
                
                
                Text("WHO WE ARE")
                    .font(Font.custom("Viga-Regular", size: 25)).bold()
                    .foregroundStyle(.white)
                    .padding(.top, 20)
                    .padding()
            }

            
            ScrollView {
                
                /// MAIN TEXT
                MissionStatementView()
                
                /// DIVIDER
                Rectangle()
                    .frame(width: 200, height: 2)
                    .foregroundStyle(.lorange)
                    
                /// INSERT LATEST INSTAGRAM POSTS
                PostCarousel(viewModel: InstagramViewModel())
                    .padding()
                
                
                /// QUOTE
                QuoteView()
                    .padding(.top, 20)
                
            }
            .padding(.top, -8)
            
        }
        .ignoresSafeArea()

    }
}

#Preview {
    AboutUsView()
}
