//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI

struct PointsView: View {
    
    @StateObject var vm : PointsViewModel
    
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
                    PointsUI(points: vm.fallPoints, semester: "Fall", percent: vm.fallPercentile)
                        .padding()
                    PointsUI(points: vm.springPoints, semester: "Spring", percent: vm.springPercentile)
                        .padding()
                    PointsUI(points: vm.summerPoints, semester: "Summer", percent: vm.summerPercentile)
                        .padding()
                }
                
                Spacer()
                Spacer()
                Spacer()
            }
            
        }
        .sheet(isPresented: $redeem, content: {
            ReedemView(vm: vm)
        })
        .ignoresSafeArea()
        
    }
    
}

#Preview {
    PointsView(vm: PointsViewModel(shpeito:
                                    SHPEito(
                                        id: "650376888bda4600144075e9",
                                        name: "Ashley Guerra",
                                        points: 0,
                                        fallPercentile: 0,
                                        springPercentile: 0,
                                        summerPercentile: 0,
                                        fallPoints: 0,
                                        springPoints: 0,
                                        summerPoints: 0,
                                        username: "ashguerra"
                                    )
                                  ))
}
