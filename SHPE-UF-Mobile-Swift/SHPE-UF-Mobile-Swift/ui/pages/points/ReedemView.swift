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
    
    @StateObject var vm : PointsViewModel
    
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
                        .textInputAutocapitalization(.never)
                    
                    Button {
                        print("Clicked")
                        vm.redeemCode(code: code)
                        vm.setShpeitoPercentiles()
                        dismiss()
                    } label: {
                        Text("Done")
                    }

                    
//                    Button("Done") {
//                        print("Clicked")
//                        vm.redeemCode(code: code)
//                        dismiss()
//                    }
                    
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                }
                
                
            }
            .ignoresSafeArea()
            .navigationTitle("")
            
            
        }
        
    }
}

#Preview {
    ReedemView(vm: PointsViewModel(shpeito:
                                    SHPEito(
                                        id: "5f595bc16b307400179595ab",
                                        name: "David Denis",
                                        points: 0,
                                        fallPercentile: 0,
                                        springPercentile: 0,
                                        summerPercentile: 0,
                                        fallPoints: 0,
                                        springPoints: 0,
                                        summerPoints: 0,
                                        username: "denis_david"
                                    )
                                  ))
}
