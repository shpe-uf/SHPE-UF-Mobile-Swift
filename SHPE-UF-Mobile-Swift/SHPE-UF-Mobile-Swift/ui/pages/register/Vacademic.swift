
import Foundation
import SwiftUI


struct AcademicView : View
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
                        Text("Enter your current education details")
                          .font(Font.custom("Univers LT Std", size: 14))
                          .foregroundColor(Color.white)
                        
                        //page 2 name
                        Text("Academic Info")
                          .font(Font.custom("Viga", size: 46))
                          .foregroundColor(Constants.Orange)
                          .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    Spacer()
                    
                    //pfp imagae
//                    Image("User_cicrle_duotone")
//                      .frame(width: 50, height: 52.5)
//                      .clipped()
                }
                .padding(.horizontal)
            
            
                Spacer()
                
                //firstname
                VStack(alignment: .leading)
                {
                    //major
                    Text("Major")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlebook")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        Picker("", selection: $viewModel.majorInput)
                        {
                            ForEach(viewModel.majorOptions, id: \.self)
                            {
                                option in Text(option).tag(option)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use this to make the picker appear as a menu
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    //year
                    Text("Year")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlecalender")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        Picker("", selection: $viewModel.yearInput)
                        {
                            ForEach(viewModel.yearOptions, id: \.self)
                            {
                                option in Text(option).tag(option)
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use this to make the picker appear as a menu
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                 
                    //grad year
                    Text("Graduation Year")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.gradcap")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
//                        Picker("", selection: $viewModel.thisYearInput)
//                        {
//                            ForEach(viewModel.thisYearOptions, id: \.self)
//                            {
//                                option in Text(option).tag(option)
//                            }
//                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use this to make the picker appear as a menu
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
                        Text("Complete Registration")
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

