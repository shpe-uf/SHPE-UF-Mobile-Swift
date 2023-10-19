//
//  ContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI
// This is a test

struct ContentView: View {
    var body: some View {
        HStack{
            VStack {
                Text("Blue Rectangle")
                Rectangle()
                    .frame(width: 375, height: 200)
                    .foregroundColor(.blue)
                
                
                
                Text("Red Rectangle")
                    .padding()
            }
        }
        Spacer()
    }
}

#Preview {
    ContentView()
}
