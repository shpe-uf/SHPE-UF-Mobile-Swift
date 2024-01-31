//
//  ReedemView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 11/16/23.
//

import SwiftUI

struct ReedemView: View {
    
    @State var code: String = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                //Gradient Background
                LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .topLeading, endPoint: .bottom)
                
                VStack {
                    Spacer()
                    
                    Text("REDEEM CODE")
                        .font(.title).bold()
                        .foregroundStyle(.white)
                    
                
                    
                    TextField("Enter Code", text: $code)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.top, 60)
                    
                    
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
                
                
            }
            .ignoresSafeArea()
            .navigationTitle("")
            .toolbar {
                Button("Done") {
                    
                    // DO VALIDATION
                    dismiss()
                }
            }
            
            
        }
        
    }
}

#Preview {
    ReedemView()
}
