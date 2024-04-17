import SwiftUI


struct RegisterView: View
{
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    @State var errorMessageDict:[Int:Bool] = [
        0: false,
        1: false,
        2: false,
        3: false
    ]
    
    
    var body: some View
    {
        ZStack
        {
            
            Color(red: 0.82, green: 0.35, blue: 0.09)
                .ignoresSafeArea()
            

               
            //gator pic
            Rectangle()
              .foregroundColor(.clear)
              .background(
                Image(colorScheme == .dark ? "Gator" : "Gator2")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 306, height: 197)
                  .clipped()
                  .offset(y: colorScheme == .dark ? -UIScreen.main.bounds.height * 0.305 : -UIScreen.main.bounds.height * 0.325)
              )
            
            if viewModel.viewIndex > 0
            {
                Button 
                {
                    viewModel.viewIndex -= 1
                } 
                label:
                {
                    ZStack 
                    {
                        Image("Ellipse_back")
                            .frame(width: 40, height: 40)
                        Image("Back")
                            .frame(width:40, height:70)
                    }
                }
                .zIndex(999)
                .position(CGPoint(x: 40.0, y: 110.0))
            }
            
            
            //dark blue box
            VStack
            {
                //scrolling bar
                HStack
                {
                    //bar 1
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                      .cornerRadius(1)
                      .onTapGesture {
                          if viewModel.onLastPage
                          {
                              viewModel.viewIndex = 0
                          }
                      }
                    
                    //bar 2
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(viewModel.viewIndex >= 1 ? Color(red: 0.82, green: 0.35, blue: 0.09) : Color(red: 0.6, green: 0.6, blue: 0.6))
                      .cornerRadius(1)
                      .onTapGesture {
                          if viewModel.onLastPage
                          {
                              viewModel.viewIndex = 1
                          }
                      }
                    //bar 3
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(viewModel.viewIndex >= 2 ? Color(red: 0.82, green: 0.35, blue: 0.09) : Color(red: 0.6, green: 0.6, blue: 0.6))
                      .cornerRadius(1)
                      .onTapGesture {
                          if viewModel.onLastPage
                          {
                              viewModel.viewIndex = 2
                          }
                      }
                }
                .padding()
                .padding(.vertical)
               
                    ZStack
                    {
                        Color(red: 0, green: 0.12, blue: 0.21)
                            .ignoresSafeArea()
                        VStack
                        {
                            //welcome textbox
                            HStack(alignment: .bottom) 
                            {
                                VStack(alignment: .leading) 
                                {
                                    Text("     Welcome to SHPE!")
                                      .font(Font.custom("Univers LT Std", size: 14))
                                      .foregroundColor(Color("whiteText"))
                                    
                                    //register textbox
                                    Text(" Register")
                                      .font(Font.custom("Viga-Regular", size: 46))
                                      .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                                      .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                
                                Spacer()
                                
                                //shpe logo
                                Image("swift.shpelogo")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 50, height: 50)
                                  .clipped()
                            }
                            .padding(.horizontal)
                        
                        
                            Spacer()
                            
                            ScrollView
                            {
                                //user fields
                                VStack(alignment: .leading)
                                {
        
                                    Text("UF/SF Email")
                                        .font(Font.custom("Univers LT Std", size: 16))
                                        .foregroundColor(Color("whiteText"))
                                        .frame(width: 150, height: 16.47059, alignment: .topLeading)
                                    HStack(spacing: 0)
                                    {
                                        Image("swift.littleletter")
                                            .padding(.horizontal, 12)
                                        TextField("", text: $viewModel.emailInput)
                                            .onChange(of: viewModel.emailInput) { newValue in
                                                // Only validate and show error after first submission attempt
                                                if viewModel.emailValidated {
                                                    viewModel.emailExists = viewModel.validateEmail() ? "" : "Invalid email format"
                                                }
                                                
                                            }
                                            .onSubmit {
                                                // Mark first submission attempt for validation
                                                viewModel.emailValidated = true
                                                viewModel.emailExists = viewModel.validateEmail() ? "" : "Invalid email format"
                                            }
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                    }
                                    .padding(.vertical, 2.75)
                                    .frame(width: 270, height: 37.64706)
                                    .background(Color.white)
                                    .cornerRadius(10)

                                    // Display the error message for email (if any)
                                    if viewModel.emailExists.count > 0 {
                                        Text(viewModel.emailExists)
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }

                                    
                                    //email validation
                                    if errorMessageDict[0]!
                                    {
                                        Text("Invalid email format")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }

                                    
                                    //username
                                    Text("Username")
                                        .font(Font.custom("Univers LT Std", size: 16))
                                        .foregroundColor(Color("whiteText"))
                                        .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                                    HStack(spacing: 0)
                                    {
                                        Image("swift.littlepfp")
                                            .padding(.horizontal, 12)
                                        TextField("", text: $viewModel.usernameInput)
                                            .onChange(of: viewModel.usernameInput) { newValue in
                                                // Only show error after first submission attempt
                                                if viewModel.usernameValidated {
                                                    viewModel.userNameExists = viewModel.validateUsername() ? "" : "6-20 characters, periods, & underscores"
                                                }
                                            }
                                            .onSubmit {
                                                // Mark the first submission attempt
                                                viewModel.usernameValidated = true
                                                viewModel.userNameExists = viewModel.validateUsername() ? "" : "6-20 characters, periods, & underscores"
                                            }
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                    }
                                    .padding(.vertical, 2.75)
                                    .frame(width: 270, height: 37.64706)
                                    .background(Color.white)
                                    .cornerRadius(10)

                                    // Display the error message (if any)
                                    if viewModel.userNameExists.count > 0 {
                                        Text(viewModel.userNameExists)
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }


                                    // Username validation
                                    if errorMessageDict[1]!
                                    {
                                        Text("6-20 characters, periods, & underscores")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }


                                    
                                    //password
                                    Text("Password")
                                        .font(Font.custom("Univers LT Std", size: 16))
                                        .foregroundColor(Color("whiteText"))
                                        .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                                    HStack(spacing: 0)
                                    {
                                        Image("swift.littlelock")
                                            .padding(.horizontal, 12)
                                        if viewModel.viewPassword
                                        {
                                            TextField("", text: $viewModel.passwordInput)
                                                .onChange(of: viewModel.passwordInput) { newValue in
                                                    if viewModel.passwordValidated { // Check if validation has been triggered at least once
                                                        errorMessageDict[2] = !viewModel.validatePassword()
                                                    }
                                                }
                                                .onSubmit {
                                                    viewModel.passwordValidated = true // Mark that user has attempted to submit at least once
                                                    errorMessageDict[2] = !viewModel.validatePassword()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(Color.black)
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                        }
                                        else
                                        {
                                            SecureField("", text: $viewModel.passwordInput)
                                                .onChange(of: viewModel.passwordInput) { newValue in
                                                    if viewModel.passwordValidated { // Check if validation has been triggered at least once
                                                        errorMessageDict[2] = !viewModel.validatePassword()
                                                    }
                                                }
                                                .onSubmit {
                                                    viewModel.passwordValidated = true // Mark that user has attempted to submit at least once
                                                    errorMessageDict[2] = !viewModel.validatePassword()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(Color.black)
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                        }
                                        
                                        // Eye icon for toggling password visibility
                                        Image(viewModel.viewPassword ? "open_eye" :"Eye Closed")
                                            .frame(width: 22.32634, height: 14.58338)
                                            .padding(.horizontal, 12)
                                            .onTapGesture { viewModel.viewPassword.toggle() }
                                    }
                                    .padding(.vertical, 2.75)
                                    .frame(width: 270, height: 37.64706)
                                    .background(Color.white)
                                    .cornerRadius(10)

                                    // Password validation
                                    if errorMessageDict[2]!
                                    {
                                        Text("8+ characters, lowercase, uppercase, number, & special character")
                                            .frame(width: 250, height: 50, alignment: .topLeading)
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                    
                                    // Eye icon for toggling confirm password visibility
                                    Image(viewModel.viewConfirmPassword ? "open_eye" : "Eye Closed")
                                        .frame(width: 22.32634, height: 14.58338)
                                        .padding(.horizontal, 12)
                                        .onTapGesture {
                                            viewModel.viewConfirmPassword.toggle()
                                        }
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)

                                // Confirm password validation
                                if errorMessageDict[3]!
                                {
                                    Text("Passwords must match")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                Spacer()

                                
                                    
                                    //confirm password
                                    Text("Confirm Password")
                                        .font(Font.custom("Univers LT Std", size: 16))
                                        .foregroundColor(Color("whiteText"))
                                        .frame(height: 16.47059, alignment: .topLeading)
                                    HStack(spacing: 0)
                                    {
                                        Image("swift.littlelock")
                                            .padding(.horizontal, 12)
                                        if viewModel.viewConfirmPassword
                                        {
                                            TextField("", text: $viewModel.passwordConfirmInput)
                                                .onChange(of: viewModel.passwordConfirmInput) { newValue in
                                                    if viewModel.passwordValidated
                                                    { // Check if validation has been triggered at least once
                                                        errorMessageDict[3] = !viewModel.validateConfirmPassword()
                                                    }
                                                }
                                                .onSubmit
                                                {
                                                    viewModel.passwordValidated = true // Mark that user has attempted to submit at least once
                                                    errorMessageDict[3] = !viewModel.validateConfirmPassword()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(Color.black)
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                        }
                                        else
                                        {
                                            SecureField("", text: $viewModel.passwordConfirmInput)
                                                .onChange(of: viewModel.passwordConfirmInput) { newValue in
                                                    if viewModel.passwordValidated { // Check if validation has been triggered at least once
                                                        errorMessageDict[3] = !viewModel.validateConfirmPassword()
                                                    }
                                                }
                                                .onSubmit {
                                                    viewModel.passwordValidated = true // Mark that user has attempted to submit at least once
                                                    errorMessageDict[3] = !viewModel.validateConfirmPassword()
                                                }
                                                .frame(maxWidth: .infinity)
                                                .foregroundStyle(Color.black)
                                                .autocapitalization(.none)
                                                .autocorrectionDisabled()
                                        }
                                        
                                        // Eye icon for toggling confirm password visibility
                                        Image(viewModel.viewConfirmPassword ? "open_eye" : "Eye Closed")
                                            .frame(width: 22.32634, height: 14.58338)
                                            .padding(.horizontal, 12)
                                            .onTapGesture {
                                                viewModel.viewConfirmPassword.toggle()
                                            }
                                    }
                                    .padding(.vertical, 2.75)
                                    .frame(width: 270, height: 37.64706)
                                    .background(Color.white)
                                    .cornerRadius(10)

                                    // Confirm password validation
                                    if errorMessageDict[3]!
                                    {
                                        Text("Passwords must match")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                    Spacer()

                                    
                                    
                                    
                                    
                                    Spacer()
                                    
                                    
                                    
                                }
                            }
                            .simultaneousGesture(DragGesture().onChanged { _ in viewModel.dismissKeyboard()})
                           
                            
                            .padding(.horizontal, 50)
                            Spacer()
                            
                            
                            //create account button
                            Button(action:
                            {
                                errorMessageDict[0] = !viewModel.validateEmail()
                                errorMessageDict[1] = !viewModel.validateUsername()
                                errorMessageDict[2] = !viewModel.validatePassword()
                                errorMessageDict[3] = !viewModel.validateConfirmPassword()
                                
                                if !errorMessageDict[0]! && !errorMessageDict[1]! && !errorMessageDict[2]! && !errorMessageDict[3]!
                                {
                                    viewModel.loading = true
                                    viewModel.validateUsernameAndEmail()
                                }
                            })
                            {
                                Text(viewModel.loading ? "Loading..." : "Create Account")
                                    .font(Font.custom("Univers LT Std", size: 16))
                                    .foregroundColor(.white)
                                    .frame(width: 351, height: 42)
                                    .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                                    .cornerRadius(20)
                            }
                            
                            Spacer()
                            
                            HStack
                            {
                                //account text
                                Text("Already have an account?")
                                  .font(Font.custom("Univers LT Std", size: 14))
                                  .foregroundColor(Color("whiteText"))

                                //button to move back to sign in page
                                Text("Sign In")
                                  .font(Font.custom("Univers LT Std", size: 14))
                                  .foregroundColor(Color("lblue"))
                                  .onTapGesture
                                  {
                                      appVM.setPageIndex(index: 0)
                                  }
                            }
                            .padding(.bottom, 40)
                        
                        }
                        .background(Color("darkBlue"))
                    }
                
                    //nav link alternative to switch views
                    .overlay(
                    Group
                    {
                        //switch to PersonalDetailsView
                        if viewModel.viewIndex == 1
                        {
                            PersonalView(viewModel: viewModel)
                        }
                        //switch to AcademicView
                        else if viewModel.viewIndex == 2
                        {
                            AcademicView(viewModel: viewModel)
                        }
                        
                    }
                )
                
                .background(Color("darkBlue"))
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.83)
            .background(Color("darkBlue"))
            .padding(.top, UIScreen.main.bounds.height * 0.17)
        }
        
        //hides keyboard on swipe
        .onAppear
        {
            viewModel.hideKeyboard = { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for:nil)}
        }
    }
}

#Preview(body:
{
    RegisterView()
})          




