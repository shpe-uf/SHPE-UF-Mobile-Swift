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
                                            username: "dvera0322",
                                            password: "",
                                            remember: "true",
                                            base64StringPhoto: "",
                                            firstName: "David",
                                            lastName: "Denis",
                                            year: "Sophmore",
                                            major: "Computer Science",
                                            id: "642f7f80e8839f0014e8be9b",
                                            token: "",
                                            confirmed: true,
                                            updatedAt: "",
                                            createdAt: "",
                                            email: "denisdavid@ufl.edu",
                                            gender: "Male",
                                            ethnicity: "Hispanic",
                                            originCountry: "Cuba",
                                            graduationYear: "2026",
                                            classes: ["Data Structures", "Discrete Structures"],
                                            internships: ["Apple"],
                                            links: ["google.com"],
                                            fallPoints: 20,
                                            summerPoints: 17,
                                            springPoints: 30,
                                            points: 67,
                                            fallPercentile: 93,
                                            springPercentile: 98,
                                            summerPercentile: 78)
                                  ))
}
