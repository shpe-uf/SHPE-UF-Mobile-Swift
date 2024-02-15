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
                Rectangle()
                  .foregroundColor(.clear)
                  .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                
                VStack {
                    Text("REDEEM POINTS")
                      .font(Font.custom("Univers LT Std", size: 35))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.93, green: 0.93, blue: 0.93))
                      .frame(alignment: .top)
                    
                    TextField("Event Code", text: $code)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .frame(height: 45)
                        .cornerRadius(5)
                        .textInputAutocapitalization(.never)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    Text("Guests")
                        .foregroundStyle(.white)
                
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: 200, maxHeight: 70)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(5)
                        HStack {
                            Button {
                                print("subtract")
                            } label: {
                                Rectangle()
                                  .foregroundColor(.clear)
                                  .frame(width: 50, height: 10)
                                  .background(Color(red: 0, green: 0.12, blue: 0.21))
                            }
                            Image("Line 7")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 0.35, height: 50)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color(red: 0, green: 0.12, blue: 0.21), lineWidth: 3)
                                )
                            Text("0") // Replace "5" with your desired number
                                .font(.headline) // Adjust font size and style as needed
                                .frame(width: 50, height: 50)

                            Image("Line 7")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 0.35, height: 50)
                                .overlay(
                                    Rectangle()
                                        .stroke(Color(red: 0, green: 0.12, blue: 0.21), lineWidth: 3)
                                )
                            Button {
                                print("add")
                            } label: {
                                Image("Group 1")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    Button {
                        print("Clicked")
                        vm.redeemCode(code: code)
                        vm.setShpeitoPercentiles()
                        dismiss()
                    } label: {
                        Text("Redeem")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color(red: 0, green: 0.12, blue: 0.21))
                            .foregroundColor(.white)
                            .cornerRadius(60)
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    Spacer()
                }
                .padding(.top, 200)
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
