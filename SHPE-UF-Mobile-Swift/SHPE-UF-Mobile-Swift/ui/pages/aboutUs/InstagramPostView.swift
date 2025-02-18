//
//  InstagramPostView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/18/25.
//

import SwiftUI

struct InstagramPostView: View {
    var body: some View {
        
        ZStack {
    
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Image("swift.shpelogo")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    Text("@shpeuf")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                
                Rectangle()
                    .opacity(0.2)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                HStack {
                    Text("shpeuf")
                        .font(.headline)
                        .bold()
                    
                    Text("...")
                }
                .padding(.leading, 3)
                
            }
            .padding()
            
        }
    }
}

#Preview {
    InstagramPostView()
}
