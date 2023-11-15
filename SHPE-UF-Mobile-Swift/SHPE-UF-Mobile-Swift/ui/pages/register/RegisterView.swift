import SwiftUI
import UIKit
// Add this extension at the top of your Swift file
extension Locale {
    static let countryNames: [String] = {
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        return countries.sorted()
    }()
}

struct RegisterView: View {
    @State var firstnameInput: String = ""
    @State var lastnameInput: String = ""
    @State var usernameInput: String = ""
    @State var passwordInput: String = ""
    @State var emailInput: String = ""
    @State var passwordConfirmInput: String = ""
    
    @State var majorInput: String = ""
    @State var yearInput: String = ""
    @State var thisYearInput: String = ""
    @State var originInput: String = ""
    @State var ethnicityInput: String = ""
    @State var genderInput: String = ""
    
    @State private var selectedMajorIndex = 0
    let majorOptions =
    [
      "Aerospace Engineering",
      "Agricultural & Biological Engineering",
      "Biomedical Engineering",
      "Chemical Engineering",
      "Civil Engineering",
      "Coastal & Oceanographic Engineering",
      "Computer Engineering",
      "Computer Science",
      "Digital Arts & Sciences",
      "Electrical Engineering",
      "Environmental Engineering Sciences",
      "Human-Centered Computing",
      "Industrial & Systems Engineering",
      "Materials Science & Engineering",
      "Mechanical Engineering",
      "Nuclear Engineering"
    ];

    let yearOptions =
    [
      "1st Year",
      "2nd Year",
      "3rd Year",
      "4th Year",
      "5th Year or Higher",
      "Graduate",
      "Ph.D."
    ];

    let thisYearOptions =
    [
        "Not Graduating",
        "Fall Semester",
        "Spring Semester",
        "Summer Semester"
    ]
    
    let originOptions = Locale.countryNames // Use the country names from the extension
    
    let ethnicityOptions =
    [
      "Option I",
      "Option II",
      "Option III",
      "American Indian or Alaska Native",
      "Asian",
      "Black or African American",
      "Hispanic/Latino",
      "Native Hawaiian or Other Pacific Islander",
      "White",
      "Two or more ethnicities",
      "Prefer not to answer"
    ];

    let genderOptions = ["Male", "Female", "Non-Binary", "Other", "Prefer not to answer"]
    
    @State private var isMajorDropdownOpen = false
    @State private var isYearDropdownOpen = false
    @State private var isThisYearDropdownOpen = false
    @State private var isOriginDropdownOpen = false
    @State private var isEthnicityDropdownOpen = false
    @State private var isGenderDropdownOpen = false

    var body: some View
    {
        ZStack
        {
            ScrollView
            {
                VStack
                {
                    Image("shpe_logo")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: UIScreen.main.bounds.width * 0.3)
                    
                    TextField("First Name", text: $firstnameInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .padding(.top, 60)
                    TextField("Last Name", text: $lastnameInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    TextField("Major", text: $majorInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onTapGesture {
                            isMajorDropdownOpen.toggle()
                        }
                    
                    // Show the Major Picker when isMajorDropdownOpen is true
                    if isMajorDropdownOpen {
                        Picker("Major", selection: $selectedMajorIndex) {
                            ForEach(0..<majorOptions.count, id: \.self) { index in
                                Text(majorOptions[index]).tag(index)
                            }
                        }
                        .pickerStyle(.wheel) // You can change the style as needed
                        .padding(.horizontal)
                    }
                    
                    TextField("Year", text: $yearInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onTapGesture {
                            isYearDropdownOpen.toggle()
                        }
                    
                    // Show the Year Picker when isYearDropdownOpen is true
                    if isYearDropdownOpen {
                        Picker("Year", selection: $yearInput) {
                            ForEach(yearOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.wheel) // You can change the style as needed
                        .padding(.horizontal)
                    }
                    
                    TextField("Graduating this year?", text: $thisYearInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onTapGesture {
                            isThisYearDropdownOpen.toggle()
                        }
                    
                    // Show the ThisYear Picker when isThisYearDropdownOpen is true
                    if isThisYearDropdownOpen {
                        Picker("Graduating this year?", selection: $thisYearInput) {
                            ForEach(thisYearOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.wheel) // You can change the style as needed
                        .padding(.horizontal)
                    }
                    
                    TextField("Country of Origin", text: $originInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onTapGesture {
                            isOriginDropdownOpen.toggle()
                        }
                    
                    // Show the Origin Picker when isOriginDropdownOpen is true
                    if isOriginDropdownOpen {
                        Picker("Country of Origin", selection: $originInput) {
                            ForEach(originOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.wheel) // You can change the style as needed
                        .padding(.horizontal)
                    }
                    
                    TextField("Ethnicity", text: $ethnicityInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onTapGesture {
                            isEthnicityDropdownOpen.toggle()
                        }
                    
                    // Show the Ethnicity Picker when isEthnicityDropdownOpen is true
                    if isEthnicityDropdownOpen {
                        Picker("Ethnicity", selection: $ethnicityInput) {
                            ForEach(ethnicityOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.wheel) // You can change the style as needed
                        .padding(.horizontal)
                    }
                    
                    TextField("Gender", text: $genderInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onTapGesture {
                            isGenderDropdownOpen.toggle()
                        }
                    
                    // Show the Gender Picker when isGenderDropdownOpen is true
                    if isGenderDropdownOpen {
                        Picker("Gender", selection: $genderInput) {
                            ForEach(genderOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.wheel) // You can change the style as needed
                        .padding(.horizontal)
                    }
                    
                    TextField("Username", text: $usernameInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    TextField("UF/SF Email", text: $emailInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    TextField("Password", text: $passwordInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    TextField("Confirm Password", text: $passwordConfirmInput)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                .zIndex(10)
                .padding(.vertical, 80)
                
            }
            .ignoresSafeArea()
            .zIndex(10)
            // Gradient Background
            LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topTrailing, endPoint: .bottomLeading)
            LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomTrailing, endPoint: .topLeading)
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .topTrailing, endPoint: .bottom)
        }
        .ignoresSafeArea()
        .navigationBarTitle("Test", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
