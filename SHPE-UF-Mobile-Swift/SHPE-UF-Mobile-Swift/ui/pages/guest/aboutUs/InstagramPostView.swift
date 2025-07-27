//
//  InstagramPostView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/18/25.
//

import SwiftUI

struct InstagramPostView: View {
    var post: InstagramPost
    
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
                
                
                AsyncImage(url: URL(string: post.media_url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                
                HStack {
                    Text("shpeuf  ").fontWeight(.bold) + Text(post.caption ?? "")
                    
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(EdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3))
                
                
            }
            .padding()
            
        }
    }
}

#Preview {
    InstagramPostView(post: InstagramViewModel().mockData[0])
}
