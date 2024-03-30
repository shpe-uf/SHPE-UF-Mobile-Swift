import Foundation
import SwiftUI


struct AcademicView : View
{
    @Environment(\.presentationMode) var isPresented
    @StateObject var viewModel: RegisterViewModel
    
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    
    var body: some View
    {
        ZStack
        {
//        HStack
//        {
//                //back button to PersonalDetailsView
//                Button
//                {
//                    viewModel.viewIndex = 1
//                    
//                }
//            label:
//                {
//                    Image(systemName: "arrowshape.turn.up.left.fill")
//                        .foregroundStyle(Color.gray)
//                        .padding()
//                        .background(Color.gray.opacity(0.5))
//                        .cornerRadius(30)
//                }
//                .padding(.horizontal)
//            }
            
            Color(red: 0, green: 0.12, blue: 0.21)
                .ignoresSafeArea()
            VStack
            {
                HStack(alignment: .bottom)
                {
                    VStack(alignment: .leading)
                    {
                        //header message
                        Text("Enter your current education details")
                          .font(Font.custom("Univers LT Std", size: 14))
                          .foregroundColor(Color("whiteText"))
                        
                        //academic info header
                        Text("Academic Info")
                          .font(Font.custom("Viga-Regular", size: 42))
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
                
                //user fields
                VStack(alignment: .leading, spacing: 10)
                {
                    //major
                    Text("Major")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color("whiteText"))
                        .frame(width: 250, alignment: .topLeading)

                    HStack(spacing: 0)
                    {
                        Image("swift.littlebook")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23.0, height: 23.0)
                            .padding(.leading, 7)

                        Spacer()

                        Picker("", selection: $viewModel.majorInput)
                        {
                            ForEach(viewModel.majorOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .accentColor(.black)
                        .onChange(of: viewModel.majorInput) { _ in viewModel.majorPickerInteracted = true }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 270, height: viewModel.calculatePickerHeight(for: viewModel.majorInput, maxWidth: 270, fontSize: 16))
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    //major validation
                    if !viewModel.validateMajorSelected() && viewModel.majorPickerInteracted
                    {
                        Text("Invalid major format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    
                    //class year
                    Text("Class Year")
                        .font(Font.custom("Univers LT Std", size: 16))
                        .foregroundColor(Color("whiteText"))
                        .frame(width: 200, alignment: .topLeading)
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlecalender")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26.0, height: 26.0)
                            .padding(.horizontal, 7)
                        
                        Spacer()

                        //dropdown for class year
                        Picker("", selection: $viewModel.classYearInput)
                        {
                            ForEach(viewModel.classYearOptions, id: \.self) 
                            {
                                option in Text(option).tag(option)
                            }
                        }
                        .accentColor(.black)
                        .onChange(of: viewModel.classYearInput) { _ in viewModel.classYearPickerInteracted = true }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 270)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    //class year validation
                    if !viewModel.validateClassYearSelected() && viewModel.classYearPickerInteracted
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

                        //dropdown for graduation year
                        Picker("", selection: $viewModel.gradYearInput)
                        {
                            ForEach(viewModel.gradYearOptions, id: \.self) 
                            {
                                option in Text(option).tag(option)
                            }
                        }
                        .accentColor(.black)
                        .onChange(of: viewModel.gradYearInput) { _ in viewModel.gradYearPickerInteracted = true }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    //grdaution year validation
                    if !viewModel.validateGradYearSelected() && viewModel.gradYearPickerInteracted 
                    {
                        Text("Invalid graduation year format")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
         
                Spacer()
                
                HStack
                {
                    VStack
                    {
                        Button(action:
                        {
                            //move to sign in if valid
                            if viewModel.isAcademicValid()
                            {
                                //move to sign in if valid
                                viewModel.majorPickerInteracted = true
                                viewModel.classYearPickerInteracted = true
                                viewModel.gradYearPickerInteracted = true
                                if viewModel.isAcademicValid()
                                {
                                    appVM.showToast = true
                                }
                                appVM.setPageIndex(index: 0)
                            }
                       
                        })
                        {
                            Text("Complete Registration")
                                .font(Font.custom("Univers LT Std", size: 16))
                                .foregroundColor(.white)
                                .frame(width: 351, height: 42, alignment: .center)
                                .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                                .cornerRadius(20)
                        }
                        .animation(.default, value: viewModel.showToast)
                        
                    
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color("darkBlue"))
        }
        .onAppear
        {
            viewModel.onLastPage = true
        }
    }
}


#Preview(body:
{
    AcademicView(viewModel: RegisterViewModel())
})
