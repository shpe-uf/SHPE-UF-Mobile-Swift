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
                
                /// LOGO
                VStack {
                    Image("swift.shpelogo")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .overlay(
                            Circle().stroke(.orangeButton, lineWidth: 2)
                        )
                        .padding()
                }
                .frame(maxWidth: .infinity)
                
                
                /// TEXT
                VStack(alignment: .center) {
                    
                    Text("SHPE")
                        .font(.system(size: 60).bold())
                    
                    Text("Leading Hispanics in STEM")
                        .font(.caption2)
                        .foregroundStyle(.orangeButton)
                    
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Empowering the Hispanic community to realize its fullest potential and to impact the world through STEM awareness, access, support and development.")
                        .font(.custom("Viga-Regular", size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                    
                    // Small Divider (Styled)
                    Rectangle()
                        .frame(width: 50, height: 2)
                        .foregroundColor(.button)
                        .padding()
                    
                    
                    Text("The Society of Hispanic Professional Engineers Chapter at the University of Florida (SHPE UF) was formerly known as the Hispanic Engineering Society. It was founded in the fall of 1982 in an effort to provide Hispanic engineers, mathematicians, and scientists with opportunities to develop as professionals while offering an amiable social environment.")
                    .font(.custom("Viga-Regular", size: 20))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    
                }
                .padding()
                
                
                
                /// INSERT LATEST INSTAGRAM POSTS
                
                
                
                
                
                
                
                
                
                
            }
            
            
            
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AboutUsView()
}
