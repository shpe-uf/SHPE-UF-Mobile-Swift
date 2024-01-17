//
//  ContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

struct SHPEUFAppView: View {
    let requestHandler = RequestHandler()
    var body: some View {
        VStack {
            Text("Create Buttons Here to test requests")
                .font(.largeTitle)
            Button(action:
            {
                requestHandler.alumniRequest()
            }, label: {
                Text("Sample Request")
            })
    
        }
        .padding(10)
        Spacer()
    }
}


#Preview {
    SHPEUFAppView()
}
