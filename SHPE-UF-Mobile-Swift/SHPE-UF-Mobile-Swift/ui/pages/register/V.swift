import SwiftUI

struct Constants
{
    static let DarkBlue: Color = Color(red: 0, green: 0.12, blue: 0.21)
    static let Orange: Color = Color(red: 0.82, green: 0.35, blue: 0.09)
    static let LightBlue: Color = Color(red: 0.58, green: 0.88, blue: 1)
    static let Grey: Color = Color(red: 0.6, green: 0.6, blue: 0.6)
}



struct RegisterView: View
{
    //@ObservedObject var viewModel = RegisterViewModel()
    @StateObject var viewModel: RegisterViewModel = RegisterViewModel()
    
    var body: some View
    {
        ZStack
        {
            Color(red: 0.82, green: 0.35, blue: 0.09)
                .ignoresSafeArea()
//            Rectangle()
//              .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
//              .ignoresSafeArea()
            
            Rectangle()
              .foregroundColor(.clear)
              .background(
                Image("swift.gator")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 306, height: 197)
                  .clipped()
              )
              .offset(y: -UIScreen.main.bounds.height * 0.305)
            
            //dark blue box
            VStack
            {
                //scrolling bar
                HStack
                {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(Constants.Orange)
                      .cornerRadius(1)
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(viewModel.viewIndex >= 1 ? Constants.Orange : Constants.Grey)
                      .cornerRadius(1)
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 106, height: 5)
                      .background(viewModel.viewIndex >= 2 ? Constants.Orange : Constants.Grey)
                      .cornerRadius(1)
                }
                .padding()
               
                NavigationView
                {
                    ZStack
                    {
                        Constants.DarkBlue
                            .ignoresSafeArea()
                        VStack
                        {
                            // Content goes here
                            //welcome textbox
                            
                           
                            HStack(alignment: .bottom) 
                            {
                                VStack(alignment: .leading) 
                                {
                                    Text("Welcome to SHPE!")
                                      .font(Font.custom("Univers LT Std", size: 14))
                                      .foregroundColor(Color.white)
                                    
                                    //register textbox
                                    Text("REGISTER")
                                      .font(Font.custom("Viga", size: 46))
                                      .foregroundColor(Constants.Orange)
                                      .frame(maxWidth: .infinity, alignment: .topLeading)
                                }
                                
                                Spacer()
                                
                                Image("swift.shpelogo")
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(width: 50, height: 50)
                                  .clipped()
                            }
                            .padding(.horizontal)
                        
                        
                            Spacer()
                            
                            VStack(alignment: .leading)
                            {
                                Text("UF Email")
                                  .font(Font.custom("Univers LT Std", size: 16))
                                  .foregroundColor(Color.white)
                                  .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                                HStack(spacing: 0)
                                {
                                    Image("swift.littleletter")
                                        .padding(.horizontal, 12)
                                    TextField("", text: $viewModel.emailInput)
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(Color.black)
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)

                                
                                //username box
                                Text("Username")
                                  .font(Font.custom("Univers LT Std", size: 16))
                                  .foregroundColor(Color.white)
                                  .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                                HStack(spacing: 0)
                                {
                                    Image("swift.littlepfp")
                                        .padding(.horizontal, 12)
                                    TextField("", text: $viewModel.usernameInput)
                                        .frame(maxWidth: .infinity)
                                        .foregroundStyle(Color.black)
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)
                                
                                
                                //password
                                Text("Password")
                                  .font(Font.custom("Univers LT Std", size: 16))
                                  .foregroundColor(Color.white)
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
                                    }
                                    else
                                    {
                                        SecureField("", text: $viewModel.passwordInput)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                    }
                                    
                                    Image(viewModel.viewPassword ? "swift.littlepfp" :"Eye Closed")
                                        .frame(width: 22.32634, height: 14.58338)
                                        .background(Color.white)
                                        .padding(.horizontal, 12)
                                        .onTapGesture {
                                            viewModel.viewPassword.toggle()
                                        }
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)

                                //confirm password
                                Text("Confirm Password")
                                  .font(Font.custom("Univers LT Std", size: 16))
                                  .foregroundColor(Color.white)
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
                                    }
                                    else
                                    {
                                        SecureField("", text: $viewModel.passwordConfirmInput)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color.black)
                                    }
                                    
                                    Image(viewModel.viewConfirmPassword ? "swift.littlepfp" : "Eye Closed")
                                        .frame(width: 22.32634, height: 14.58338)
                                        .background(Color.white)
                                        .padding(.horizontal, 12)
                                        .onTapGesture {
                                            viewModel.viewConfirmPassword.toggle()
                                        }
                                }
                                .padding(.vertical, 2.75)
                                .frame(width: 270, height: 37.64706)
                                .background(Color.white)
                                .cornerRadius(10)

                                
                            }
                            Spacer()
                            
                            
                            NavigationLink
                            {
                                // your next view
                                PersonalView(viewModel: self.viewModel)
                                    .navigationBarHidden(true)
                            }
                            label:
                            {
                                Text("Create Account")
                                  .font(Font.custom("Univers LT Std", size: 16))
                                  .foregroundColor(.white)
                                  .frame(width: 351, height: 42)
                                  .background(Constants.Orange)
                                  .cornerRadius(20)
                            }
                            .isDetailLink(false)
                    
                            HStack
                            {
                                Text("Already have an account?")
                                  .font(Font.custom("Univers LT Std", size: 14))
                                  .foregroundColor(Color.white)

                                Text("Sign In")
                                  .font(Font.custom("Univers LT Std", size: 14))
                                  .foregroundColor(Constants.LightBlue)
                            }
                            .padding(.bottom, 40)
                        
                        }
                        .background(Constants.DarkBlue)
                    }
                    .onAppear {
                        print("here")
                        viewModel.viewIndex = 0
                    }
                    
                }
                .background(Constants.DarkBlue)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.83)
            .background(Constants.DarkBlue)
            .padding(.top, UIScreen.main.bounds.height * 0.17)
            
            //orange rectangle 7 at the top
            
            
            

//                    Rectangle()
//                      .foregroundColor(.clear)
//                      .frame(width: 106, height: 5)
//                      .background(Constants.Orange)
//                      .cornerRadius(1)
//
//                    Rectangle()
//                      .foregroundColor(.clear)
//                      .frame(width: 106, height: 5)
//                      .background(Constants.Grey)
//                      .cornerRadius(1)
//
//                    Rectangle()
//                      .foregroundColor(.clear)
//                      .frame(width: 106, height: 5)
//                      .background(Constants.Grey)
//                      .cornerRadius(1)
        
               // VStack
//                    {
//                        //welcome textbox
//                        Text("Welcome to SHPE!")
//                          .font(Font.custom("Univers LT Std", size: 14))
//                          .foregroundColor(Color.white)
//                         // .position(x: 150, y: 150)
//
//                        //register textbox
//                        Text("REGISTER")
//                          .font(Font.custom("Viga", size: 46))
//                          .foregroundColor(Constants.Orange)
//                          .frame(width: 225, height: 42, alignment: .topLeading)
//
//                        //logo
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 50, height: 50)
//                          .background(
//                            Image("swift.shpelogo")
//                              .resizable()
//                              .aspectRatio(contentMode: .fill)
//                              .frame(width: 50, height: 50)
//                              .clipped()
//                          )
//
//                        //email
//                        Text("UF Email")
//                          .font(Font.custom("Univers LT Std", size: 16))
//                          .foregroundColor(Color.white)
//                          .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
//                        HStack(alignment: .center, spacing: 0) {  Image("swift.littleletter") }
//                        .padding(.horizontal, 1.83333)
//                        .padding(.vertical, 2.75)
//                        .frame(width: 22, height: 22, alignment: .center)
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 270, height: 37.64706)
//                          .background(Color.white)
//                          .cornerRadius(10)
//
//                        //username box
//                        Text("Username")
//                          .font(Font.custom("Univers LT Std", size: 16))
//                          .foregroundColor(Color.white)
//                          .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
//                        HStack(alignment: .center, spacing: 0) {Image("swift.littlepfp") }
//                        .padding(1.83333)
//                        .frame(width: 22, height: 22, alignment: .center)
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 270, height: 37.64706)
//                          .background(Color.white)
//                          .cornerRadius(10)
//
//                        //password
//                        Text("Password")
//                          .font(Font.custom("Univers LT Std", size: 16))
//                          .foregroundColor(Color.white)
//                          .frame(width: 95.59006, height: 16.47059, alignment: .topLeading)
//                        Image("Eye Closed")
//                          .frame(width: 22.32634, height: 14.58338)
//                          .background(Color.white)
//                        HStack(alignment: .center, spacing: 0) { Image("swift.littlelock") }
//                        .padding(.horizontal, 3)
//                        .padding(.vertical, 2)
//                        .frame(width: 24, height: 24, alignment: .center)
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 270, height: 37.64706)
//                          .background(Color.white)
//                          .cornerRadius(10)
//
//                        //confirm password
//                        Text("Confirm password")
//                          .font(Font.custom("Univers LT Std", size: 16))
//                          .foregroundColor(Color.white)
//                          .frame(width: 155.15837, height: 16.47059, alignment: .topLeading)
//                        Image("Eye Closed")
//                          .frame(width: 22.32634, height: 14.58338)
//                          .background(Color.white)
//                        HStack(alignment: .center, spacing: 0) { Image("swift.littlelock") }
//                        .padding(.horizontal, 3)
//                        .padding(.vertical, 2)
//                        .frame(width: 24, height: 24, alignment: .center)
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 270, height: 37.64706)
//                          .background(Color.white)
//                          .cornerRadius(10)
//
//                        //create account button
//                        Text("Create Account")
//                          .font(Font.custom("Univers LT Std", size: 16))
//                          .foregroundColor(.white)
//                          .frame(width: 115, height: 23, alignment: .leading)
//                        Rectangle()
//                          .foregroundColor(.clear)
//                          .frame(width: 351, height: 42)
//                          .background(Constants.Orange)
//                          .cornerRadius(20)
//
//                        Text("Already have an account?")
//                          .font(Font.custom("Univers LT Std", size: 14))
//                          .foregroundColor(Color.white)
//
//                        Text("Sign In")
//                          .font(Font.custom("Univers LT Std", size: 14))
//                          .foregroundColor(Constants.LightBlue)
//
////
////                        TextField("First Name", text: $viewModel.firstnameInput)
////                            .textFieldStyle(TransparentTextFieldStyle())
////                            .border(viewModel.isFirstNameValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
//////                            .onChange{ newValue in
//////                                DispatchQueue.main.async{
//////                                    viewModel.isFirstNameValid = Validation.validateName(newValue)
//////                                }
//////
//////                        }
//
//
////                        TextField("Last Name", text: $viewModel.lastnameInput)
////                            .textFieldStyle(TransparentTextFieldStyle())
////                            .border(viewModel.isLastNameValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
//////                            .onChange(of: viewModel.lastnameInput) { newValue in
//////                                viewModel.isLastNameValid = Validation.validateName(newValue)
//////                            }
////
////                        TextField("Username", text: $viewModel.usernameInput)
////                            .textFieldStyle(TransparentTextFieldStyle())
////                            .border(viewModel.isUsernameValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
//////                            .onChange(of: viewModel.usernameInput) { newValue in
//////                                viewModel.isUsernameValid = Validation.validateUsername(newValue) // Assuming validateUsername is a static method in Validation
//////                            }
////
////                        SecureField("Password", text: $viewModel.passwordInput)
////                            .textFieldStyle(TransparentTextFieldStyle())
////                            .border(viewModel.isPasswordValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
//////                            .onChange(of: viewModel.passwordInput) { newValue in
//////                                viewModel.isPasswordValid = Validation.validatePassword(newValue) // Assuming validatePassword is a static method in Validation
//////                                viewModel.isPasswordConfirmValid = Validation.passwordsMatch(newValue, viewModel.passwordConfirmInput) // Assuming passwordsMatch is a static method in Validation
//////                            }
////
////                        SecureField("Confirm Password", text: $viewModel.passwordConfirmInput)
////                            .textFieldStyle(TransparentTextFieldStyle())
////                            .border(viewModel.isPasswordConfirmValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
//////                            .onChange(of: viewModel.passwordConfirmInput) { newValue in
//////                                viewModel.isPasswordConfirmValid = Validation.passwordsMatch(viewModel.passwordInput, newValue) // Assuming passwordsMatch is a static method in Validation
//////                            }
////
////                        TextField("UF/SF Email", text: $viewModel.emailInput)
////                            .textFieldStyle(TransparentTextFieldStyle())
////                            .border(viewModel.isEmailValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
//////                            .onChange(of: viewModel.emailInput) { newValue in
//////                                viewModel.isEmailValid = Validation.validateEmail(newValue) // Assuming validateEmail is a static method in Validation
//////                            }
//
//
//
////                        Menu {
////                            Picker("Major", selection: $viewModel.selectedMajorIndex) {
////                                ForEach(0..<viewModel.majorOptions.count, id: \.self) {
////                                    Text(viewModel.majorOptions[$0]).tag($0)
////                                }
////                            }
////                        }
////                        label: {
////                            HStack {
////                                Text(viewModel.majorInput.isEmpty ? "Select Major" : viewModel.majorInput)
////                                    .foregroundColor(viewModel.majorInput.isEmpty ? .white : .white)
////                                    .padding(.leading, 10)
////                                Spacer()
////                            }
////                            .frame(height: 44)
////                            .background(RoundedRectangle(cornerRadius: 5).stroke(viewModel.isMajorValid ? Color.gray : Color.red))
////                            .padding(.horizontal)
////                        }
////                        .onChange(of: viewModel.selectedMajorIndex) { newValue in
////                            viewModel.majorInput = viewModel.majorOptions[newValue]
////                            viewModel.isMajorValid = Validation.validateMajor(viewModel.majorInput, majorOptions: viewModel.majorOptions)
////                        }
////
////
////
////                        Menu {
////                            Picker("Year", selection: $viewModel.selectedYearIndex) {
////                                ForEach(0..<viewModel.yearOptions.count, id: \.self) {
////                                    Text(viewModel.yearOptions[$0]).tag($0)
////                                }
////                            }
////                        }
////
////                        label: {
////                            HStack {
////                                Text(viewModel.yearInput.isEmpty ? "Select Year" : viewModel.yearInput)
////                                    .foregroundColor(viewModel.yearInput.isEmpty ? .gray : .white)
////                                    .padding(.leading, 10)
////                                Spacer()
////                            }
////                            .frame(height: 44)
////                            .background(RoundedRectangle(cornerRadius: 5).stroke(viewModel.isYearValid ? Color.gray : Color.red))
////                            .padding(.horizontal)
////                        }
////
////                        .onChange(of: viewModel.selectedYearIndex) { newValue in
////                            viewModel.yearInput = viewModel.yearOptions[newValue]
////                            viewModel.isYearValid = viewModel.Validation.validateYear(viewModel.yearInput, yearOptions: viewModel.yearOptions)
////                        }
////
////
////                        // For Graduating This Year
////                        Menu {
////                            Picker("Graduating this year?", selection: $viewModel.selectedThisYearIndex) {
////                                ForEach(0..<viewModel.thisYearOptions.count, id: \.self) {
////                                    Text(viewModel.thisYearOptions[$0]).tag($0)
////                                }
////                            }
////                        }
////
////                        label: {
////                            HStack {
////                                Text(viewModel.thisYearInput.isEmpty ? "Select Graduation Year" : viewModel.thisYearInput)
////                                    .foregroundColor(viewModel.thisYearInput.isEmpty ? .gray : .white)
////                                    .padding(.leading, 10)
////                                Spacer()
////                            }
////                            .frame(height: 44)
////                            .background(RoundedRectangle(cornerRadius: 5).stroke(viewModel.isThisYearValid ? Color.gray : Color.red))
////                            .padding(.horizontal)
////                        }
////
////                        .onChange(of: viewModel.selectedThisYearIndex) { newValue in
////                            viewModel.thisYearInput = viewModel.thisYearOptions[newValue]
////                            viewModel.isThisYearValid = viewModel.Validation.validateThisYear(viewModel.thisYearInput, thisYearOptions: viewModel.thisYearOptions)
////                        }
////
////                        // For Country of Origin
////                        Menu {
////                            Picker("Country of Origin", selection: $viewModel.originInput) {
////                                ForEach(viewModel.originOptions, id: \.self) {
////                                    Text($0).tag($0)
////                                }
////                            }
////                        }
////
////                        label: {
////                            HStack {
////                                Text(viewModel.originInput.isEmpty ? "Select Country of Origin" : viewModel.originInput)
////                                    .foregroundColor(viewModel.originInput.isEmpty ? .gray : .white)
////                                    .padding(.leading, 10)
////                                Spacer()
////                            }
////                            .frame(height: 44)
////                            .background(RoundedRectangle(cornerRadius: 5).stroke(viewModel.isOriginValid ? Color.gray : Color.red))
////                            .padding(.horizontal)
////                        }
////
////                        .onChange(of: viewModel.originInput) { newValue in
////                            viewModel.isOriginValid = viewModel.Validation.validateOrigin(viewModel.originInput, originOptions: viewModel.originOptions)
////                        }
////
////                        // For Ethnicity
////                        Menu {
////                            Picker("Ethnicity", selection: $viewModel.ethnicityInput) {
////                                ForEach(viewModel.ethnicityOptions, id: \.self) {
////                                    Text($0).tag($0)
////                                }
////                            }
////                        }
////
////                        label: {
////                            HStack {
////                                Text(viewModel.ethnicityInput.isEmpty ? "Select Ethnicity" : viewModel.ethnicityInput)
////                                    .foregroundColor(viewModel.ethnicityInput.isEmpty ? .gray : .white)
////                                    .padding(.leading, 10)
////                                Spacer()
////                            }
////                            .frame(height: 44)
////                            .background(RoundedRectangle(cornerRadius: 5).stroke(viewModel.isEthnicityValid ? Color.gray : Color.red))
////                            .padding(.horizontal)
////                        }
////
////                        .onChange(of: viewModel.ethnicityInput) { newValue in
////                            viewModel.isEthnicityValid = viewModel.Validation.validateEthnicity(viewModel.ethnicityInput, ethnicityOptions: viewModel.ethnicityOptions)
////                        }
////
////                        // For Gender
////                        Menu {
////                            Picker("Gender", selection: $viewModel.genderInput) {
////                                ForEach(viewModel.genderOptions, id: \.self) {
////                                    Text($0).tag($0)
////                                }
////                            }
////                        }
////
////                        label: {
////                            HStack {
////                                Text(viewModel.genderInput.isEmpty ? "Select Gender" : viewModel.genderInput)
////                                    .foregroundColor(viewModel.genderInput.isEmpty ? .gray : .white)
////                                    .padding(.leading, 10)
////                                Spacer()
////                            }
////                            .frame(height: 44)
////                            .background(RoundedRectangle(cornerRadius: 5).stroke(viewModel.isGenderValid ? Color.gray : Color.red))
////                            .padding(.horizontal)
////                        }
////
////                        .onChange(of: viewModel.genderInput) { newValue in
////                            viewModel.isGenderValid = viewModel.Validation.validateGender(viewModel.genderInput, genderOptions: viewModel.genderOptions)
////                        }
//
////                        Rectangle()
////                            .frame(width: UIScreen.main.bounds.width, height: 1)
////                            .foregroundColor(.white)
//
//
////                        Button(action: {if validateAllFields(){showConfirmationView = true}})
////                        {
////                            Text("Register")
////                                // Button styling...
////                        }
////                        .padding(.horizontal)
////                        .disabled(!validateAllFields())
////
////                         //Add a hidden NavigationLink
////                        NavigationLink(destination: ConfirmationView(), isActive: $showConfirmationView)
////                        {
////                            EmptyView()
////                        }
//                        Button(action: { viewModel.registerUser() })
//                        {
//                            // Button label
//                        }
//
////                        {
////                        if validateAllFields()
////                        {
////                            requestHandler.registerUser(firstName: firstnameInput, lastName: lastnameInput, major: majorInput, year: yearInput, graduating: thisYearInput, country: originInput, ethnicity: ethnicityInput, sex: genderInput, username: usernameInput, email: emailInput, password: passwordInput, confirmPassword: passwordConfirmInput)
////                            { dict in
////                                // Check if error is inside dict
////                                if dict["error"] != nil
////                                {
////                                    print("")
////                                    //change button, processing request try again maybe
////                                    return
////                                }
////                                // If error not there
////                                showConfirmationView = true
////                            }
////                        }
////                        }
//
//
//
//
////
////                        .disabled(!viewModel.validateAllFields())
////                        .opacity(!viewModel.validateAllFields() ? 0.6 : 1.0)
//
//                        // Hidden NavigationLink
////                        NavigationLink(destination: ConfirmationView(), isActive: $showConfirmationView) {
////                            EmptyView()
////                        }
//
//                    }
//                    .zIndex(10)
//                    .padding(.vertical, 80)
                
        
        }
        
    }
}
