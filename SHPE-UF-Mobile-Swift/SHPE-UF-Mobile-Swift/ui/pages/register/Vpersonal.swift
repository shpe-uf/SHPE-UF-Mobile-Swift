//
//  Vpersonal.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by test on 2/13/24.
//

import Foundation
import SwiftUI


struct PersonalView : View
{
    @Environment(\.presentationMode) var isPresented
    @StateObject var viewModel: RegisterViewModel
    
    var body: some View
    {
        ZStack
        {
            Constants.DarkBlue
                .ignoresSafeArea()
            VStack
            {
                HStack(alignment: .bottom)
                {
                    VStack(alignment: .leading)
                    {
                        //top message
                        Text("Enter your info to finalize your profile")
                          .font(Font.custom("Univers LT Std", size: 14))
                          .foregroundColor(Color.white)
                        
                        //page 2 name
                        Text("Personal Details")
                          .font(Font.custom("Viga", size: 46))
                          .foregroundColor(Constants.Orange)
                          .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    Spacer()
                    
                    //pfp imagae
                    Image("User_cicrle_duotone")
                      .frame(width: 50, height: 52.5)
                      .clipped()
                }
                .padding(.horizontal)
            
            
                Spacer()
                
                //firstname
                VStack(alignment: .leading)
                {
                    Text("First Name")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color.white)
                      .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                    HStack(spacing: 0)
                    {
                        Image("swift.littlepfp")
                            .padding(.horizontal, 12)
                        TextField("", text: $viewModel.firstnameInput)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 2.75)
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)

                    
                    //lastname
                    Text("Last Name")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color.white)
                      .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                    HStack(spacing: 0)
                    {
                        Image("swift.littlepfp")
                            .padding(.horizontal, 12)
                        TextField("", text: $viewModel.lastnameInput)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 2.75)
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    
                    //gender
                    Text("Gender")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color.white)
                      .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                    HStack(spacing: 0)
                    {
                        Image("swift.littlegender")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        TextField("", text: $viewModel.genderInput)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 2.75)
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    
                    
                    //ethnicity
                    Text("Ethncity")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color.white)
                      .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                    HStack(spacing: 0)
                    {
                        Image("swift.littleearth")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        TextField("", text: $viewModel.ethnicityInput)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.black)
                    }
                    .padding(.vertical, 2.75)
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    
//                    VStack {
//                        Text("Country of Origin")
//                            .font(Font.custom("Univers LT Std", size: 16))
//                            .foregroundColor(Color.white)
//                            .frame(width: 200, height: 16.47059, alignment: .topLeading)
//                        
//                        HStack(spacing: 0) {
//                            Image("swift.littleearth")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 26.0, height: 26.0)
//                                .padding(.horizontal, 8)
//
//                            Picker("", selection: $viewModel.originInput) {
//                                Text("").tag(String?.none)
//                                ForEach(viewModel.originOptions, id: \.self) { option in
//                                    Text(option).tag(option as String?)
//                                }
//                            }
//                            .padding(.horizontal, 50)
//                            .pickerStyle(MenuPickerStyle()) // Use this to make the picker appear as a menu
//                            .accentColor(.black) // Change the accent color to modify the appearance
//                        }
//                        .frame(width: 270, height: 37.64706)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                    }

//
                    Text("Country of Origin")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littleearth")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        Picker("", selection: $viewModel.originInput)
                        {
                            ForEach(viewModel.originOptions, id: \.self)
                            {
                                option in Text(option).tag(option)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use this to make the picker appear as a menu
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                 

                    
//                    //origin
//                    Text("Country of Origin")
//                      .font(Font.custom("Univers LT Std", size: 16))
//                      .foregroundColor(Color.white)
//                      .frame(width: 200, height: 16.47059, alignment: .topLeading)
//                    HStack(spacing: 0)
//                    {
//                        Image("swift.littleearth")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 26.0, height: 26.0)
//                            .padding(.horizontal, 7)
//                        Menu 
//                        {
//                           Picker("Country of Origin", selection: $viewModel.originInput) 
//                            {
//                               ForEach(viewModel.originOptions, id: \.self) {
//                                   Text($0).tag($0)
//                               }
//                           }
//                        }
////                        TextField("", text: $viewModel.originInput)
////                            .frame(maxWidth: .infinity)
////                            .foregroundStyle(Color.black)
//                    }
//                    .padding(.vertical, 2.75)
//                    .frame(width: 270, height: 37.64706)
//                    .background(Color.white)
//                    .cornerRadius(10)

                    
                }
                
                Spacer()
                Spacer()
                
                HStack
                {
                    Button 
                    {
                        isPresented.wrappedValue.dismiss()
                    } 
                    label:
                    {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .foregroundStyle(Color.gray)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)

                    
                    NavigationLink
                    {
                        AcademicView(viewModel: self.viewModel)
                            .navigationBarHidden(true)
                            .onAppear
                            {
                                viewModel.viewIndex = 2
                            }
                    }
                    label:
                    {
                        Text("Continue")
                          .font(Font.custom("Univers LT Std", size: 16))
                          .foregroundColor(.white)
                          .frame(width: 250, height: 42)
                          .background(Constants.Orange)
                          .cornerRadius(20)
                    }
                    .isDetailLink(false)
                }
                .padding(.bottom, 40)
            
            }
            .background(Constants.DarkBlue)
        }
        .onAppear {
            viewModel.viewIndex = 1
        }

    }
}

