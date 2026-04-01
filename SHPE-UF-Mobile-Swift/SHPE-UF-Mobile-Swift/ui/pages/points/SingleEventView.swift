//
//  SingleEventView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI

struct SingleEventView: View {
    var name: String = "Fall GBM 6"
    var date: String = "11/08/2023"
    var points: Int = 1
    
    var body: some View {
        
        VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 15) {
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .multilineTextAlignment(TextAlignment.leading)
                            .foregroundStyle(.primary)
                        
                        Text(date)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("\(points) \(points == 1 ? "point" : "points")")
                
                    Image(systemName: "person.3.fill")
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color(.systemBlue))
                }
                .font(Font.custom("Viga-Regular", size: 15))
                .padding()
        }
    }
}

#Preview {
    SingleEventView()
}

