//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI

struct PointsView: View {
    
    // THIS WILL HAVE AN OBJECT FROM VIEWMODEL (SHPEito)
    
    @State private var redeem = false;
    
    
    var body: some View {
        
        ZStack {
            //Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
            LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .topLeading, endPoint: .bottom)
            
            VStack {
                
                Spacer()
                
                ZStack {
                    
                    HStack {
                        
                        Text("POINTS PROGRAM")
                            .font(.title).bold()
                            .foregroundStyle(.white)
                        
                        
                        Image("shpe_logo")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.27, height: UIScreen.main.bounds.width * 0.27)
                        
                    }
                    .padding(.vertical)
                }
                
                Button {
                    redeem.toggle()
                } label: {
                    ReedemPointsButton()
                        .foregroundColor(.black)
                }
                .padding(.bottom)
                
                         
                
                VStack {
                    PointsUI(points: 12, semester: "Fall", percent: 89)
                        .padding()
                    PointsUI(points: 12, semester: "Spring", percent: 34)
                        .padding()
                    PointsUI(points: 12, semester: "Summer", percent: 90)
                        .padding()
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            
        }
        .sheet(isPresented: $redeem, content: {
            ReedemView()
        })
        .ignoresSafeArea()
        
    }
    
}

#Preview {
    PointsView()
}
