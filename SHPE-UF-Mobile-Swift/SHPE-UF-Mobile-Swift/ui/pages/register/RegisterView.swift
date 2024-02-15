//import SwiftUI
//import UIKit
//
////The View Model will be responsible for holding the functions that will send requests to the server.
////vm vars and validation locale, later confirmated
////take var out of view
//
//// Add this extension at the top of your Swift file
////extension Locale
////{
////    static let countryNames: [String] =
////    {
////        var countries: [String] = []
////        for code in NSLocale.isoCountryCodes
////        {
////            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
////            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
////            countries.append(name)
////        }
////        return countries.sorted()
////    }()
////}
////
////struct Validation
////{
////
////// Regular expressions used for validation
////    private static let nameRegex = "^[a-zA-Z ',.-]{3,20}$"
////    private static let usernameRegex = "^(?=.{6,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
////    private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
////    private static let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}|:<>?]).{8,}$"
////
////    // Validation function for a name (first name or last name)
////    static func validateName(_ name: String) -> Bool
////    {
////        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
////        return namePredicate.evaluate(with: name)
////    }
////    
////    static func validateEmail(_ email: String) -> Bool
////    {
////        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
////        return emailPredicate.evaluate(with: email)
////    }
////    
////    static func passwordsMatch(_ password1: String, _ password2: String) -> Bool {
////        return validatePassword(password1) && password1 == password2
////    }
////    
////    static func validateMajor(_ major: String, majorOptions: [String]) -> Bool {
////        return majorOptions.contains(major)
////    }
////    
////    static func validateYear(_ year: String, yearOptions: [String]) -> Bool {
////        return yearOptions.contains(year)
////    }
////
////    static func validateThisYear(_ thisYear: String, thisYearOptions: [String]) -> Bool {
////        return thisYearOptions.contains(thisYear)
////    }
////    
////    static func validateOrigin(_ origin: String, originOptions: [String]) -> Bool {
////        return originOptions.contains(origin)
////    }
////
////    static func validateEthnicity(_ ethnicity: String, ethnicityOptions: [String]) -> Bool {
////        return ethnicityOptions.contains(ethnicity)
////    }
////    
////    static func validateGender(_ gender: String, genderOptions: [String]) -> Bool {
////        return genderOptions.contains(gender)
////    }
////    
////    static func validatePassword(_ password: String) -> Bool {
////        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
////        return passwordPredicate.evaluate(with: password)
////    }
////
////
////    // Add other validation functions here following the same pattern
////}
//
//struct TransparentTextFieldStyle: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        configuration
//            .padding(10)
//            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
//            .shadow(radius: 2)
//    }
//}

//struct ConfirmationView: View
//{
//    var body: some View
//    {
//        ZStack
//        {
//            // Background Gradients
//            LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//            
//            LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
//                .ignoresSafeArea()
//
//            VStack(spacing: 30) { // Increased spacing for better layout
//                // SHPE Logo Image (Made larger)
//                Image("shpe_logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
//                    .frame(width: UIScreen.main.bounds.width * 0.5) // Increase width to 50% of screen width
//
//                // Text with enhanced design
//                Text("Check your email for confirmation")
//                    .font(.largeTitle) // Large title font
//                    .fontWeight(.bold) // Bold font weight
//                    .foregroundColor(Color.white) // White color for contrast
//                    .multilineTextAlignment(.center) // Center alignment for multiline text
//                    .padding()
//                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5) // Shadow for depth
//                    .scaleEffect(1.1) // Slightly larger scale for emphasis
//                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID()) // Gentle scaling animation
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity) // VStack takes the full size of the parent view
//            .padding(.vertical) // Padding to ensure content does not touch the screen edges
//        }
//    }
//}
//
//
//
//
//
//
//struct RegisterView: View
//{
//    private var requestHandler = RequestHandler()
//    //move to vm @published
//    @State var firstnameInput: String = ""
//    @State var lastnameInput: String = ""
//    @State var usernameInput: String = ""
//    @State var passwordInput: String = ""
//    @State var emailInput: String = ""
//    @State var passwordConfirmInput: String = ""
//    @State var majorInput: String = ""
//    @State var yearInput: String = ""
//    @State var thisYearInput: String = ""
//    @State var originInput: String = ""
//    @State var ethnicityInput: String = ""
//    @State var genderInput: String = ""
//    
//    //data validation bools
//    @State var isFirstNameValid = false
//    @State var isLastNameValid = false
//    @State var isUsernameValid = false
//    @State var isEmailValid = false
//    @State var isPasswordValid = false
//    @State var isPasswordConfirmValid = false
//    @State var isMajorValid = false
//    @State var isYearValid = false
//    @State var isThisYearValid = false
//    @State var isOriginValid = false
//    @State var isEthnicityValid = false
//    @State var isGenderValid = false
//    @State var isConfirmPasswordValid = false
//    
//    @State private var selectedYearIndex: Int = 0
//    @State private var selectedThisYearIndex: Int = 0
//
//
//    
//    @State private var showConfirmationView = false
//
//    
//    
//    @State private var selectedMajorIndex = 0
//    let majorOptions =
//    [
//      "Aerospace Engineering",
//      "Agricultural & Biological Engineering",
//      "Biomedical Engineering",
//      "Chemical Engineering",
//      "Civil Engineering",
//      "Coastal & Oceanographic Engineering",
//      "Computer Engineering",
//      "Computer Science",
//      "Digital Arts & Sciences",
//      "Electrical Engineering",
//      "Environmental Engineering Sciences",
//      "Human-Centered Computing",
//      "Industrial & Systems Engineering",
//      "Materials Science & Engineering",
//      "Mechanical Engineering",
//      "Nuclear Engineering"
//    ];
//
//    let yearOptions =
//    [
//      "1st Year",
//      "2nd Year",
//      "3rd Year",
//      "4th Year",
//      "5th Year or Higher",
//      "Graduate",
//      "Ph.D."
//    ];
//
//    let thisYearOptions =
//    [
//        "Not Graduating",
//        "Fall Semester",
//        "Spring Semester",
//        "Summer Semester"
//    ]
//    
//    let originOptions = Locale.countryNames // Use the country names from the extension
//    
//    let ethnicityOptions =
//    [
//      "American Indian or Alaska Native",
//      "Asian",
//      "Black or African American",
//      "Hispanic/Latino",
//      "Native Hawaiian or Other Pacific Islander",
//      "White",
//      "Two or more ethnicities",
//      "Prefer not to answer"
//    ];
//
//    let genderOptions = ["Male", "Female", "Non-Binary", "Other", "Prefer not to answer"]
//    
//    @State private var isMajorDropdownOpen = false
//    @State private var isYearDropdownOpen = false
//    @State private var isThisYearDropdownOpen = false
//    @State private var isOriginDropdownOpen = false
//    @State private var isEthnicityDropdownOpen = false
//    @State private var isGenderDropdownOpen = false
//    @State private var tempSelectedMajorIndex: Int?
//
//
//    var body: some View
//    {
//        NavigationView
//        {
//           ZStack
//            {
//                LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing) .ignoresSafeArea()
//
//               LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
//                   .ignoresSafeArea()
//
//               LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .topLeading, endPoint: .bottom)
//                   .ignoresSafeArea()
//                
//                ScrollView
//                {
//                    VStack
//                    {
//                        Image("shpe_logo")
//                            .resizable()
//                            .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
//                        
//                        TextField("First Name", text: $firstnameInput)
//                            .textFieldStyle(TransparentTextFieldStyle())
//                            .border(isFirstNameValid ? Color.gray : Color.red)
//                            .padding(.horizontal)
//                            .onChange(of: firstnameInput) { newValue in isFirstNameValid = Validation.validateName(newValue)}
//
//                        TextField("Last Name", text: $lastnameInput)
//                            .textFieldStyle(TransparentTextFieldStyle())
//                            .border(isLastNameValid ? Color.gray : Color.red)
//                            .padding(.horizontal)
//                            .onChange(of: lastnameInput) {newValue in isLastNameValid = Validation.validateName(newValue)}
//                        
//                        TextField("Username", text: $usernameInput)
//                            .textFieldStyle(TransparentTextFieldStyle())
//                            .border(isUsernameValid ? Color.gray : Color.red)
//                            .padding(.horizontal)
//                            .onChange(of: usernameInput, perform:{newValue in validateUsername(username: newValue)})
//                        
//                        SecureField("Password", text: $passwordInput)
//                            .textFieldStyle(TransparentTextFieldStyle())
//                            .border(isPasswordValid ? Color.gray : Color.red)
//                            .padding(.horizontal)
//                            .onChange(of: passwordInput) { newValue in
//                                isPasswordValid = Validation.validatePassword(newValue)
//                                isConfirmPasswordValid = Validation.passwordsMatch(passwordInput, passwordConfirmInput)
//                            }
//
//                        SecureField("Confirm Password", text: $passwordConfirmInput)
//                            .textFieldStyle(TransparentTextFieldStyle())
//                            .border(isConfirmPasswordValid ? Color.gray : Color.red)
//                            .padding(.horizontal)
//                            .onChange(of: passwordConfirmInput) { newValue in
//                                isConfirmPasswordValid = Validation.passwordsMatch(passwordInput, newValue)
//                            }
//
//                        TextField("UF/SF Email", text: $emailInput)
//                            .textFieldStyle(TransparentTextFieldStyle())
//                            .border(isEmailValid ? Color.gray : Color.red)
//                            .padding(.horizontal)
//                            .onChange(of: emailInput) {newValue in isEmailValid = Validation.validateEmail(newValue)}
//
//                        Menu
//                        {
//                            Picker("Major", selection: $selectedMajorIndex)
//                            {
//                                ForEach(0..<majorOptions.count, id: \.self)
//                                {
//                                    Text(majorOptions[$0]).tag($0)
//                                }
//                            }
//                        }
//                        
//                        label:
//                        {
//                            HStack
//                            {
//                                Text(majorInput.isEmpty ? "Select Major" : majorInput)
//                                    .foregroundColor(majorInput.isEmpty ? .white : .white)
//                                    .padding(.leading, 10)
//                                Spacer()
//                            }
//                            .frame(height: 44)
//                            .background(RoundedRectangle(cornerRadius: 5).stroke(isMajorValid ? Color.gray : Color.red))
//                            .padding(.horizontal)
//                        }
//        
//                        .onChange(of: selectedMajorIndex)
//                        {
//                            newValue in majorInput = majorOptions[newValue]
//                            isMajorValid = Validation.validateMajor(majorInput, majorOptions: majorOptions)
//                        }
//                        
//                        Menu
//                        {
//                            Picker("Year", selection: $selectedYearIndex)
//                            {
//                                    ForEach(0..<yearOptions.count, id: \.self)
//                                {
//                                        Text(yearOptions[$0]).tag($0)
//                                    }
//                                }
//                        }
//                        
//                        label:
//                        {
//                            HStack
//                            {
//                                    Text(yearInput.isEmpty ? "Select Year" : yearInput)
//                                        .foregroundColor(yearInput.isEmpty ? .white : .white)
//                                        .padding(.leading, 10)
//                                    Spacer()
//                            }
//                                .frame(height: 44)
//                                .background(RoundedRectangle(cornerRadius: 5).stroke(isYearValid ? Color.gray : Color.red))
//                                .padding(.horizontal)
//                        }
//                        .onChange(of: selectedYearIndex)
//                        {
//                            newValue in yearInput = yearOptions[newValue]
//                            isYearValid = Validation.validateYear(yearInput, yearOptions: yearOptions)
//                        }
//
//                       
////                        .onChange(of: selectedMajorIndex) { newValue in
////                            isMajorValid = newValue >= 0 && newValue < majorOptions.count
////                            if isMajorValid {
////                                majorInput = majorOptions[newValue]
////                            }
////                        }
////                        HStack {
////                                                    Text(majorInput.isEmpty ? "Select Major" : majorInput)
////                                                        .foregroundColor(majorInput.isEmpty ? .gray : .black)
////                                                        .padding(.leading, 10)
////                                                    Spacer()
////                                                }
////                                                .frame(height: 44)
////                                                .background(RoundedRectangle(cornerRadius: 5).stroke(isMajorValid ? Color.gray : Color.red))
////                                                .padding(.horizontal)
////                                                .onTapGesture {
////                                                    // Toggle the picker visibility
////                                                    isMajorDropdownOpen.toggle()
////                                                }
////
////                                                // Actual Picker that will be shown/hidden based on isMajorDropdownOpen
////                                                if isMajorDropdownOpen {
////                                                    Picker("Major", selection: $selectedMajorIndex) {
////                                                        ForEach(0..<majorOptions.count, id: \.self) {
////                                                            Text(majorOptions[$0]).tag($0)
////                                                        }
////                                                    }
////                                                    .pickerStyle(.menu)
////                                                    .onChange(of: selectedMajorIndex) { newValue in
////                                                        isMajorValid = newValue >= 0 && newValue < majorOptions.count
////                                                        if isMajorValid {
////                                                            majorInput = majorOptions[newValue]
////                                                        }
////                                                    }
////                                                }
//                        
//                        
////                        TextField("Major", text: $majorInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isMajorValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onTapGesture {
////                                isMajorDropdownOpen.toggle()
////                            }
////                            .onChange(of: majorInput) { newValue in
////                                isMajorValid = Validation.validateMajor(newValue, majorOptions: majorOptions)
////                            }
////
////
////                        // Show the Major Picker when isMajorDropdownOpen is true
////                        if isMajorDropdownOpen
////                        {
////                            Picker("Major", selection: $selectedMajorIndex)
////                            {
////                                ForEach(0..<majorOptions.count, id: \.self)
////                                {
////                                    index in Text(majorOptions[index]).tag(index)
////                                }
////                            }
////                            .pickerStyle(.wheel) // You can change the style as needed
////                            .padding(.horizontal)
////                        }
////                        Picker("Major", selection: $selectedMajorIndex) {
////                                                    ForEach(0..<majorOptions.count, id: \.self) {
////                                                        Text(majorOptions[$0]).tag($0)
////                                                    }
////                                                }
////                                                .pickerStyle(.menu)
////                                                .onChange(of: selectedMajorIndex) { newValue in
////                                                    isMajorValid = newValue >= 0 && newValue < majorOptions.count
////                                                    if isMajorValid {
////                                                        majorInput = majorOptions[newValue]
////                                                    }
////                                                }
////                        Picker("Year", selection: $selectedYearIndex) {
////                                   ForEach(0..<yearOptions.count, id: \.self) { index in
////                                       Text(self.yearOptions[index]).tag(index)
////                                   }
////                               }
////                               .pickerStyle(.wheel) // or any other style you prefer
////                               .padding(.horizontal)
////
////                               // Bind the yearInput to the selected option
////                               .onChange(of: selectedYearIndex) { newValue in
////                                   yearInput = yearOptions[newValue]
////                                   isYearValid = Validation.validateYear(yearInput, yearOptions: yearOptions)
////                               }
//                        
////                        TextField("Year", text: $yearInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isYearValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onTapGesture {
////                                isYearDropdownOpen.toggle()
////                            }
////                            .onChange(of: yearInput) { newValue in
////                                isYearValid = Validation.validateYear(newValue, yearOptions: yearOptions)
////                            }
//////
//////
//////                        // Show the Year Picker when isYearDropdownOpen is true
////                        if isYearDropdownOpen
////                        {
////                            Picker("Year", selection: $yearInput)
////                            {
////                                ForEach(yearOptions, id: \.self)
////                                {
////                                    option in Text(option).tag(option)
////                                }
////                            }
////                            .pickerStyle(.wheel) // You can change the style as needed
////                            .padding(.horizontal)
////                        }
//                        Menu
//                        {
//                            Picker("Graduating this year?", selection: $selectedThisYearIndex)
//                            {
//                                    ForEach(0..<thisYearOptions.count, id: \.self)
//                                {
//                                    Text(thisYearOptions[$0]).tag($0)
//                                }
//                            }
//                            
//                        }
//                        label:
//                        {
//                            HStack
//                            {
//                                Text(thisYearInput.isEmpty ? "Select Graduation Year" : thisYearInput)
//                                    .foregroundColor(thisYearInput.isEmpty ? .gray : .white)
//                                    .padding(.leading, 10)
//                                Spacer()
//                            }
//                            .frame(height: 44)
//                            .background(RoundedRectangle(cornerRadius: 5).stroke(isThisYearValid ? Color.gray : Color.red))
//                            .padding(.horizontal)
//                        }
//                            .onChange(of: selectedThisYearIndex)
//                        {
//                            newValue in thisYearInput = thisYearOptions[newValue]
//                            isThisYearValid = Validation.validateThisYear(thisYearInput, thisYearOptions: thisYearOptions)
//                        }
////                        TextField("Graduating this year?", text: $thisYearInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isThisYearValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onTapGesture {
////                                isThisYearDropdownOpen.toggle()
////                            }
////                            .onChange(of: thisYearInput) { newValue in
////                                isThisYearValid = Validation.validateThisYear(newValue, thisYearOptions: thisYearOptions)
////                            }
////
////
////                        // Show the ThisYear Picker when isThisYearDropdownOpen is true
////                        if isThisYearDropdownOpen
////                        {
////                            Picker("Graduating this year?", selection: $thisYearInput)
////                            {
////                                ForEach(thisYearOptions, id: \.self)
////                                {
////                                    option in Text(option).tag(option)
////                                }
////                            }
////                            .pickerStyle(.wheel) // You can change the style as needed
////                            .padding(.horizontal)
////                        }
//                        Menu
//                        {
//                            Picker("Country of Origin", selection: $originInput)
//                            {
//                                ForEach(originOptions, id: \.self)
//                                {
//                                        Text($0).tag($0)
//                                }
//                            }
//                        }
//                        
//                        label:
//                        {
//                            HStack
//                            {
//                                Text(originInput.isEmpty ? "Select Country of Origin" : originInput)
//                                    .foregroundColor(originInput.isEmpty ? .gray : .white)
//                                    .padding(.leading, 10)
//                                Spacer()
//                            }
//                            .frame(height: 44)
//                            .background(RoundedRectangle(cornerRadius: 5).stroke(isOriginValid ? Color.gray : Color.red))
//                            .padding(.horizontal)
//                        }
//                            .onChange(of: originInput)
//                            {
//                            newValue in isOriginValid = Validation.validateOrigin(originInput, originOptions: originOptions)
//                            }
////                        TextField("Country of Origin", text: $originInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isOriginValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onTapGesture {
////                                isOriginDropdownOpen.toggle()
////                            }
////                            .onChange(of: originInput) { newValue in
////                                isOriginValid = Validation.validateOrigin(newValue, originOptions: originOptions)
////                            }
////
////
////                        // Show the Origin Picker when isOriginDropdownOpen is true
////                        if isOriginDropdownOpen
////                        {
////                            Picker("Country of Origin", selection: $originInput)
////                            {
////                                ForEach(originOptions, id: \.self)
////                                {
////                                    option in Text(option).tag(option)
////                                }
////                            }
////                            .pickerStyle(.wheel) // You can change the style as needed
////                            .padding(.horizontal)
////                        }
//                        
//                        Menu
//                        {
//                            Picker("Ethnicity", selection: $ethnicityInput)
//                            {
//                                ForEach(ethnicityOptions, id: \.self)
//                                {
//                                    Text($0).tag($0)
//                                }
//                            }
//                        }
//                        label:
//                        {
//                            HStack
//                            {
//                                Text(ethnicityInput.isEmpty ? "Select Ethnicity" : ethnicityInput)
//                                    .foregroundColor(ethnicityInput.isEmpty ? .gray : .white)
//                                    .padding(.leading, 10)
//                                Spacer()
//                            }
//                            .frame(height: 44)
//                            .background(RoundedRectangle(cornerRadius: 5).stroke(isEthnicityValid ? Color.gray : Color.red))
//                            .padding(.horizontal)
//                        }
//                        .onChange(of: ethnicityInput)
//                        {
//                            newValue in isEthnicityValid = Validation.validateEthnicity(ethnicityInput, ethnicityOptions: ethnicityOptions)
//                        }
//
//                                               
//                        Menu
//                        {
//                            Picker("Gender", selection: $genderInput)
//                            {
//                                ForEach(genderOptions, id: \.self)
//                                {
//                                    Text($0).tag($0)
//                                }
//                            }
//                        }
//                        label:
//                        {
//                            HStack
//                            {
//                                Text(genderInput.isEmpty ? "Select Gender" : genderInput)
//                                    .foregroundColor(genderInput.isEmpty ? .gray : .white)
//                                    .padding(.leading, 10)
//                                Spacer()
//                            }
//                            .frame(height: 44)
//                            .background(RoundedRectangle(cornerRadius: 5).stroke(isGenderValid ? Color.gray : Color.red))
//                            .padding(.horizontal)
//                        }
//                        .onChange(of: genderInput)
//                        {
//                            newValue in isGenderValid = Validation.validateGender(genderInput, genderOptions: genderOptions)
//                        }
//                        
//                        
////                        TextField("Ethnicity", text: $ethnicityInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isEthnicityValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onTapGesture {
////                                isEthnicityDropdownOpen.toggle()
////                            }
////                            .onChange(of: ethnicityInput) { newValue in
////                                isEthnicityValid = Validation.validateEthnicity(newValue, ethnicityOptions: ethnicityOptions)
////                            }
////
////                        if isEthnicityDropdownOpen
////                        {
////                            Picker("Ethnicity", selection: $ethnicityInput)
////                            {
////                                ForEach(ethnicityOptions, id: \.self)
////                                {
////                                    option in Text(option).tag(option)
////                                }
////                            }
////                            .pickerStyle(.wheel) // You can change the style as needed
////                            .padding(.horizontal)
////                        }
////
////                        TextField("Gender", text: $genderInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isGenderValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onTapGesture {
////                                isGenderDropdownOpen.toggle()
////                            }
////                            .onChange(of: genderInput) { newValue in
////                                isGenderValid = Validation.validateGender(newValue, genderOptions: genderOptions)
////                            }
////
////
////                        // Show the Gender Picker when isGenderDropdownOpen is true
////                        if isGenderDropdownOpen
////                        {
////                            Picker("Gender", selection: $genderInput)
////                            {
////                                ForEach(genderOptions, id: \.self)
////                                {
////                                    option in Text(option).tag(option)
////                                }
////                            }
////                            .pickerStyle(.wheel) // You can change the style as needed
////                            .padding(.horizontal)
////                        }
//                    
////                        TextField("Password", text: $passwordInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isPasswordValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onChange(of: passwordInput) { _ in
////                                isPasswordValid = Validation.validatePassword(passwordInput)
////                                isConfirmPasswordValid = Validation.passwordsMatch(passwordInput, passwordConfirmInput)
////                            }
////
////                        TextField("Confirm Password", text: $passwordConfirmInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isConfirmPasswordValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onChange(of: passwordConfirmInput) { _ in
////                                isConfirmPasswordValid = Validation.passwordsMatch(passwordInput, passwordConfirmInput)
////                            }
//
//                        // ... other code ...
//
////                        TextField("Password", text: $passwordInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isPasswordValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onChange(of: passwordInput) { _ in
////                                isPasswordValid = Validation.validatePassword(passwordInput)
////                                isConfirmPasswordValid = Validation.passwordsMatch(passwordInput, passwordConfirmInput)
////                                print("Password: \(passwordInput), Valid: \(isPasswordValid), Confirm Valid: \(isConfirmPasswordValid)")
////                            }
////
////
////
////                        TextField("Confirm Password", text: $passwordConfirmInput)
////                            .textFieldStyle(.roundedBorder)
////                            .border(isConfirmPasswordValid ? Color.gray : Color.red)
////                            .padding(.horizontal)
////                            .onChange(of: passwordConfirmInput) { _ in
////                                isConfirmPasswordValid = Validation.passwordsMatch(passwordInput, passwordConfirmInput)
////                                print("Confirm Password: \(passwordConfirmInput), Confirm Valid: \(isConfirmPasswordValid)")
////                            }
//
//                
//
//                        
//                        Rectangle()
//                            .frame(width: UIScreen.main.bounds.width, height: 1)
//                            .foregroundColor(.white)
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
//                        Button(action: {
//                        if validateAllFields()
//                        {
//                            requestHandler.registerUser(firstName: firstnameInput, lastName: lastnameInput, major: majorInput, year: yearInput, graduating: thisYearInput, country: originInput, ethnicity: ethnicityInput, sex: genderInput, username: usernameInput, email: emailInput, password: passwordInput, confirmPassword: passwordConfirmInput)
//                            { dict in
//                                // Check if error is inside dict
//                                if dict["error"] != nil
//                                {
//                                    print("")
//                                    //change button, processing request try again maybe
//                                    return
//                                }
//                                // If error not there
//                                showConfirmationView = true
//                            }
//                        }
//                        })
//                        {
//                            Text("Register")
//                                .fontWeight(.semibold)
//                                .font(.system(size: 20))
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
//                                .cornerRadius(40)
//                                .shadow(radius: 10)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 40)
//                                        .stroke(Color.white, lineWidth: 2)
//                                )
//                                .padding(.horizontal, 30)
//                        }
//                        .disabled(!validateAllFields())
//                        .opacity(!validateAllFields() ? 0.6 : 1.0)
//
//                        // Hidden NavigationLink
//                        NavigationLink(destination: ConfirmationView(), isActive: $showConfirmationView) {
//                            EmptyView()
//                        }
//
//                    }
////                    .zIndex(10)
////                    .padding(.vertical, 80)
//                    
//                }
////                .ignoresSafeArea()
////                .zIndex(10)
//            }
//        }
//    }
//    
//    
//    
//    func validateUsername(username: String) {
//            isUsernameValid = !username.isEmpty && username.count >= 1
//        }
//
//    
//    func validateAllFields() -> Bool
//    {
//        var isValid = true
//
//        // Validate each field
//        isValid = isValid && Validation.validateName(firstnameInput)
//        isValid = isValid && Validation.validateName(lastnameInput)
//        isValid = isValid && Validation.validateEmail(emailInput)
//        isValid = isValid && isMajorValid
//        isValid = isValid && isYearValid
//        isValid = isValid && isThisYearValid
//        isValid = isValid && isOriginValid
//        isValid = isValid && isEthnicityValid
//        isValid = isValid && isGenderValid
//        isValid = isValid && Validation.validatePassword(passwordInput)
//        isValid = isValid && isConfirmPasswordValid
//
//
//        
////        isValid = isValid && Validation.validatePassword(passwordInput)
////        isValid = isValid && isConfirmPasswordValid
//        // Add other validations here following the same pattern
//        // isValid = isValid && Validation.validateUsername(usernameInput)
//        // isValid = isValid && Validation.validateEmail(emailInput)
//        // And so on for other fields...
//
//        return isValid
//    }
//
//}
//
//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            RegisterView()
//        }
//    }
//}
//
//
////struct RegisterView_Previews: PreviewProvider {
////    static var previews: some View {
////        RegisterView()
////    }
////}
//
////#Preview {
////    RegisterView(vm: RegisterViewModel(shpeito:
////                                    SHPEito(
////                                        id: "64f7d5ce08f7e8001456248a",
////                                        name: "Daniel Parra",
////                                        points: 0)
////                                  ))
////}
////
