//
//  ReedemView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 11/16/23.
//

import SwiftUI

struct ReedemView: View {
    
    @State var code: String = "" // stores event code
    @State private var numberOfGuests = 0 // track number of guests
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm : PointsViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                
                VStack {
                    // Title
                    Text("REDEEM POINTS")
                      .font(Font.custom("Univers LT Std 65 Bold Oblique", size: 35))
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.93, green: 0.93, blue: 0.93))
                      .frame(alignment: .top)
                    
                    // Event Code Text Field
                    TextField("Event Code", text: $code)
                        .frame(height: 55)
                        .background(Color.white)
                        .font(Font.custom("Univers LT Std 55 Oblique", size: 20))
                        .textInputAutocapitalization(.never)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
    
                    Text("Guests")
                        .padding(.top, 30)
                        .foregroundStyle(.white)

                    // Guests Container
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: 200, maxHeight: 70)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(5)
                        
                        HStack {
                            // Subtract Button
                            Button(action: {
                                if numberOfGuests > 0 {
                                    numberOfGuests -= 1
                                    print("subtract")
                                }
                            })
                            {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 45, height: 8)
                                    .background(Color(red: 0, green: 0.12, blue: 0.21))
                            }
                            .padding(.trailing, 3)

                            // Left Divider
                            Image("Line 6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 55)
                            
                            // "Guests"
                            Text("\(numberOfGuests)")
                              .font(
                                Font.custom("Inter", size: 30)
                                  .weight(.medium)
                              )
                              .frame(width: 50, height: 50)

                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.28, green: 0.27, blue: 0.27).opacity(0.71))
                            
                            // Right Divider
                            Image("Line 6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 55)
                            
                            // Add Guests Button
                            Button {
                                if numberOfGuests <= 4 {
                                    numberOfGuests += 1
                                    print("add")
                                }
                            } label: {
                                Image("plus")
                                    .resizable()
                                    .padding(.leading, 5)
                                    .frame(width: 45, height: 45)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Redeem Button
                    Button {
                        print("Clicked")
                        vm.redeemCode(code: code, guests: numberOfGuests)
                        vm.setShpeitoPercentiles()
                        dismiss()
                    } label: {
                        Text("Redeem")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .font(Font.custom("Univers LT Std 45 Light", size: 20))
                            .background(Color(red: 0, green: 0.12, blue: 0.21))
                            .foregroundColor(.white)
                            .cornerRadius(22)
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

