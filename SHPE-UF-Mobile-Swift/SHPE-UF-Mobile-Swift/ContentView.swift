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
        VStack {
            Text("This is a test!")
            Rectangle()
                .frame(width: 375, height: 200)
                .foregroundColor(.green)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
