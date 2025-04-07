import Foundation
import SwiftUI

/// The second step of the registration process that collects user's personal information.
///
/// `PersonalView` follows the account credentials step and gathers essential personal details:
/// - First and last name
/// - Gender selection
/// - Ethnicity
/// - Country of origin
///
/// Each field includes real-time validation with appropriate feedback to ensure
/// data quality before proceeding to the final academic information step.
///
/// This view shares the same view model as the other registration steps,
/// allowing seamless data flow through the multi-step registration process.
struct PersonalView : View
{
    @Environment(\.presentationMode) var isPresented
    @StateObject var viewModel: RegisterViewModel
    
    var body: some View
    {
        ZStack
        {
            Color("darkBlue")
                .ignoresSafeArea()
            VStack
            {
                HStack(alignment: .bottom)
                {
                    VStack(alignment: .leading)
                    {
                        //header message
                        Text("Enter your info to finalize your profile")
                          .font(Font.custom("Univers LT Std", size: 14))
                          .foregroundColor(Color("whiteText"))
                        
                        //personal details header
                        Text("Personal Details")
                          .font(Font.custom("Viga-Regular", size: 37))
                          .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
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
                
                //user fields
                ScrollView
                {
                    
                    VStack(alignment: .leading)
                    {
                        //first name
                        Text("First Name")
                          .font(Font.custom("Univers LT Std", size: 16))
                          .foregroundColor(Color("whiteText"))
                          .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                        HStack(spacing: 0)
                        {
                            Image("swift.littlepfp")
                                .padding(.horizontal, 12)
                            TextField("", text: $viewModel.firstnameInput)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.black)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .onSubmit { viewModel.firstNameValidated = true }
                        }
                        .padding(.vertical, 2.75)
                        .frame(width: 270, height: 37.64706)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        //first name validation
                        if !viewModel.validateFirstName() && viewModel.firstNameValidated 
                        {
                            Text("3-20 characters, no special characters or numbers")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        
                        //last name
                        Text("Last Name")
                          .font(Font.custom("Univers LT Std", size: 16))
                          .foregroundColor(Color("whiteText"))
                          .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                        HStack(spacing: 0)
                        {
                            Image("swift.littlepfp")
                                .padding(.horizontal, 12)
                            TextField("", text: $viewModel.lastnameInput)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.black)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                                .onSubmit { viewModel.lastNameValidated = true }
                        }
                        .padding(.vertical, 2.75)
                        .frame(width: 270, height: 37.64706)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        //last name validation
                        if !viewModel.validateLastName() && viewModel.lastNameValidated 
                        {
                            Text("3-20 characters, no special characters or numbers")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        
                        //gender
                        Text("Gender")
                          .font(Font.custom("Univers LT Std", size: 16))
                          .foregroundColor(Color("whiteText"))
                          .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                        HStack(spacing: 0)
                        {
                            Image("swift.littlegender")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 26.0, height: 26.0)
                                .padding(.horizontal, 7)
                            
                            Spacer()
                            
                            //dropdown for gender
                            Picker("", selection: $viewModel.genderInput) 
                            {
                                ForEach(viewModel.genderOptions, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .accentColor(.black)
                            .onChange(of: viewModel.genderInput, {
                                viewModel.genderPickerInteracted = true
                            })
                        }
                        .padding(.vertical, 2.75)
                        .frame(width: 270, height: 37.64706)
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        //gender validation
                        if !viewModel.validateGenderSelected() && viewModel.genderPickerInteracted 
                        {
                            Text("Gender selection is required")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        
                        //ethnicity
                        Text("Ethncity")
                          .font(Font.custom("Univers LT Std", size: 16))
                          .foregroundColor(Color("whiteText"))
                          .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                        
                        HStack(spacing: 0)
                        {
                            Image("swift.littleearth")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 23.0, height: 26.0)
                                .padding(.horizontal, 7)
                            
                            Spacer()
                            
                            //dropdown for ethnicity
                            Picker("", selection: $viewModel.ethnicityInput) 
                            {
                                ForEach(viewModel.ethnicityOptions, id: \.self) 
                                {
                                    option in Text(option).tag(option)
                                }
                            }
                            .accentColor(.black)
                            .onChange(of: viewModel.ethnicityInput, { viewModel.ethnicityPickerInteracted = true })
                        }
                        .padding(.vertical, 2.75)
                        .frame(width: 270, height: viewModel.calculatePickerHeight(for: viewModel.ethnicityInput, maxWidth: 270, fontSize: 16))
                        .background(Color.white)
                        .cornerRadius(10)
                        
                        //ethnicity validation
                        if !viewModel.validateEthnicitySelected() && viewModel.ethnicityPickerInteracted
                        {
                            Text("Ethnicity is required")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        
                        //origin
                        Text("Country of Origin")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Color("whiteText"))
                            .frame(width: 200, height: 16.47059, alignment: .topLeading)
                        
                        HStack(spacing: 0)
                        {
                            Image("swift.littleearth")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 23.0, height: 26.0)
                                .padding(.horizontal, 7)
                            
                            Spacer()
                            
                            //dropdown for origin
                            Picker("", selection: $viewModel.originInput)
                            {
                                ForEach(viewModel.originOptions, id: \.self)
                                {
                                    option in Text(option).tag(option)
                                }
                            }
                            .accentColor(.black)
                            .onChange(of: viewModel.originInput, { viewModel.originPickerInteracted = true })
                       }
                       .pickerStyle(MenuPickerStyle())
                       .frame(width: 270, height: viewModel.calculatePickerHeight(for: viewModel.originInput, maxWidth: 270, fontSize: 18))
                       .background(Color.white)
                       .cornerRadius(10)
                        
                        //origin validation
                        if !viewModel.validateCountryOfOriginSelected() && viewModel.originPickerInteracted 
                        {
                            Text("Country of Origin is required")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 50)
                }
//                .padding(.horizontal, 50)
                
                Spacer()
                
                HStack
                {
                    //back button
                    Button(action: 
                    {
                        //move to AcademicView if valid
                        viewModel.firstNameValidated = true
                        viewModel.lastNameValidated = true
                        viewModel.genderPickerInteracted = true
                        viewModel.ethnicityPickerInteracted = true
                        viewModel.originPickerInteracted = true
                        if viewModel.isPersonalValid()
                        {
                            viewModel.viewIndex = 2
                        }
                    })
                    {
                        Text("Continue")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(.white)
                            .frame(width: 351, height: 42)
                            .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                            .cornerRadius(20)
                    }

                }
                .padding(.bottom, 40)
            }
            .background(Color("darkBlue"))
        }
    }
}

#Preview(body: 
{
    PersonalView(viewModel: RegisterViewModel())
})

