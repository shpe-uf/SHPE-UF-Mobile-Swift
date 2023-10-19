//
//  ContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack{
            VStack {
                Text("This is test1")
                
                
                
                
                
                
                Text("This is test2")
                Rectangle()
                    .frame(width: 375, height: 200)
                    .foregroundColor(.blue)
            }
            
            
        }
        Spacer()
    }
}


#Preview {
    ContentView()
}
