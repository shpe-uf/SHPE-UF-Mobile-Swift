import SwiftUI


struct RegisterView: View
{
    @Environment(\.colorScheme) var colorScheme
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    
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
                    
                    //bar 2
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(viewModel.viewIndex >= 1 ? Color(red: 0.82, green: 0.35, blue: 0.09) : Color(red: 0.6, green: 0.6, blue: 0.6))
                      .cornerRadius(1)
                    //bar 3
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(viewModel.viewIndex >= 2 ? Color(red: 0.82, green: 0.35, blue: 0.09) : Color(red: 0.6, green: 0.6, blue: 0.6))
                      .cornerRadius(1)
                }
                .padding()
                .padding(.vertical)
               
                
                NavigationView
                {
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
                                    Text("Welcome to SHPE!")
                                      .font(Font.custom("Univers LT Std", size: 14))
                                      .foregroundColor(Color("whiteText"))
                                    
                                    //register textbox
                                    Text("Register")
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
                            
                            //fields
                            VStack(alignment: .leading)
                            {
    
                                Text("UF Email")
                                    .font(Font.custom("Univers LT Std", size: 16))
                                    .foregroundColor(Color("whiteText"))
                                    .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                                HStack(spacing: 0) 
                                {
                                    Image("swift.littleletter")
                                        .padding(.horizontal, 12)
                                    TextField("", text: $viewModel.emailInput)
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(Color.black)
                                        .autocapitalization(.none)
                                        .autocorrectionDisabled()
                                        .onChange(of: viewModel.emailInput) { _ in}
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                //email validation
                                if !viewModel.validateEmail()
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
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(Color.black)
                                        .autocapitalization(.none)
                            .autocorrectionDisabled()
                                        .onChange(of: viewModel.emailInput) { _ in}
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                //username validation
                                if !viewModel.validateUsername()
                                {
                                    Text("6-20 characters, no special characters except periods (.) & underscores (_)")
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
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .onChange(of: viewModel.passwordInput) { _ in }
                                            
                                    }
                                    else
                                    {
                                        SecureField("", text: $viewModel.passwordInput)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .onChange(of: viewModel.passwordInput) { _ in }
                                           
                                    }
                                    
                                    Image(viewModel.viewPassword ? "swift.littlepfp" :"Eye Closed")
                                        .frame(width: 22.32634, height: 14.58338)
                                        .padding(.horizontal, 12)
                                        .onTapGesture {
                                            viewModel.viewPassword.toggle()
                                        }
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                // Display validation result
                                if !viewModel.validatePassword() {
                                    Text("Minimum 8 characters with lowercase, uppercase, number, & special character")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }

                                
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
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .onChange(of: viewModel.passwordConfirmInput) { newValue in }
                                        
                                    }
                                    else
                                    {
                                        SecureField("", text: $viewModel.passwordConfirmInput)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                            .onChange(of: viewModel.passwordConfirmInput) { newValue in }
                                          
                                    }
                                    
                                    Image(viewModel.viewConfirmPassword ? "swift.littlepfp" : "Eye Closed")
                                        .frame(width: 22.32634, height: 14.58338)
                                        .padding(.horizontal, 12)
                                        .onTapGesture
                                        {
                                            viewModel.viewConfirmPassword.toggle()
                                        }
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                // Display validation result
                                if !viewModel.validateConfirmPassword() 
                                {
                                    Text("Passwords must match")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                Spacer()
                                
                            }
                            .padding(.horizontal, 50)
                            Spacer()
                            
                            //create account button
                            Button(action:
                            {
//                                if viewModel.isRegisterValid() 
//                                {
                                    viewModel.shouldNavigate = true
                               // }
                            })
                            {
                                Text("Create Account")
                                    .font(Font.custom("Univers LT Std", size: 16))
                                    .foregroundColor(.white)
                                    .frame(width: 351, height: 42)
                                    .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                                    .cornerRadius(20)
                            }

                            NavigationLink(destination: PersonalView(viewModel: self.viewModel)
                                .navigationBarHidden(true), isActive: $viewModel.shouldNavigate) 
                            {
                                EmptyView()
                            }
                            .isDetailLink(false)
                            .hidden()
                    
                            Spacer()
                            
                            //sign in
                            HStack
                            {
                                Text("Already have an account?")
                                  .font(Font.custom("Univers LT Std", size: 14))
                                  .foregroundColor(Color("whiteText"))

                                //todo add link to sign in when its made
                                Text("Sign In")
                                  .font(Font.custom("Univers LT Std", size: 14))
                                  .foregroundColor(Color("lblue"))
                                  .onTapGesture {
                                      appVM.setPageIndex(index: 0)
                                  }
                            }
                            .padding(.bottom, 40)
                        
                        }
                        .background(Color("darkBlue"))
                    }
                    
                }
                .background(Color("darkBlue"))
            }
            .onAppear
            {
                viewModel.viewIndex = 0
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.83)
            .background(Color("darkBlue"))
            .padding(.top, UIScreen.main.bounds.height * 0.17)
        }
        
    }
}

#Preview(body: {
    RegisterView()
})
