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
            Color(red: 0, green: 0.12, blue: 0.21)
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
                          .foregroundColor(Color("whiteText"))
                        
                        //page 2 name
                        Text("Academic Info")
                          .font(Font.custom("Viga-Regular", size: 46))
                          .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                          .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    
                    Spacer()
                    
                    //pfp imagae
                    Image("swift.orangebook")
                      .frame(width: 50, height: 52.5)
                      .clipped()
                }
                .padding(.horizontal)
            
            
                Spacer()
                
                //fields
                VStack(alignment: .leading)
                {
                    //major
                    Text("Major")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color("whiteText"))
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlebook")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        Spacer()
                        Picker("", selection: $viewModel.majorInput)
                        {
                            ForEach(viewModel.majorOptions, id: \.self)
                            {
                                option in Text(option).tag(option)
                            }
                        }
                        .accentColor(.black)
                        .onChange(of: viewModel.majorInput) { _ in }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    if !viewModel.validateMajorSelected()
                    {
                        Text("Invalid major format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    //class Year
                    Text("Class Year")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color("whiteText"))
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlecalender")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        
                        Spacer()
                        Picker("", selection: $viewModel.classYearInput)
                        {
                            ForEach(viewModel.classYearOptions, id: \.self)
                            {
                                option in Text(option).tag(option)
                            }
                        }
                        .accentColor(.black)
                        .onChange(of: viewModel.classYearInput) { _ in }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    //class year validation
                    if !viewModel.validateClassYearSelected()
                    {
                        Text("Invalid class year format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                 
                    //graduation year
                    Text("Graduation Year")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color("whiteText"))
                        .frame(width: 200, height: 16.47059, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.gradcap")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        
                            Spacer()
                            Picker("", selection: $viewModel.gradYearInput)
                            {
                                ForEach(viewModel.gradYearOptions, id: \.self)
                                {
                                    option in Text(option).tag(option)
                                }
                            }
                            .accentColor(.black)
                            .onChange(of: viewModel.gradYearInput) { _ in }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    //grdaution year validation
                    if !viewModel.validateGradYearSelected()
                    {
                        Text("Invalid graduation year format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

                }
         
                Spacer()
                
                HStack
                {
                    //back button
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

                    //nav back to landing page
                    NavigationLink(destination: placeholderForLandingPageView(viewModel: self.viewModel), isActive: $viewModel.shouldNavigate2)
                    {
                        VStack
                        {
                            // Your existing content
                            Button(action:
                            {
                                if viewModel.isAcademicValid()
                                {
                                    
                                    viewModel.registerUser()
                                    viewModel.showToast = true
                                    // Hide toast after 3 seconds
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3)
                                    {
                                        viewModel.showToast = false
                                    }
                                }
                           
                            })
                            {
                                Text("Complete Registration")
                                    .font(Font.custom("Univers LT Std", size: 16))
                                    .foregroundColor(.white)
                                    .frame(width: 250, height: 42)
                                    .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                                    .cornerRadius(20)
                            }
                            .animation(.default, value: viewModel.showToast)
                            
                            if viewModel.showToast && viewModel.isAcademicValid()
                              {
                                  ToastView(message: "Registered!")
                                  .transition(.move(edge: .top).combined(with: .opacity))
                                  .zIndex(2) // Ensure the toast is above other content
                              }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color("darkBlue"))
        }
        .onAppear 
        {
            viewModel.viewIndex = 2
        }
        .navigationBarBackButtonHidden(true)
    }
}


struct ToastView: View 
{
    var message: String
    
    var body: some View 
    {
        Text(message)
            .padding()
            .background(Color.yellow)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 10)
            .padding(.top, 44)
    }
}

#Preview(body: {
    AcademicView(viewModel: RegisterViewModel())
})


