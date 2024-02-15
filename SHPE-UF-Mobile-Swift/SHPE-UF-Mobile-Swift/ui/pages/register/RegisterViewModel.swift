//
//import Foundation
//import UIKit
//import SwiftUI
//
//extension Locale
//{
//    
//    static let countryNames: [String] =
//    {
//        var countries: [String] = []
//        for code in NSLocale.isoCountryCodes
//        {
//            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
//            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
//            countries.append(name)
//        }
//        return countries.sorted()
//    }()
//}
//
//class RegisterViewModel
//{
//
//
//    struct Validation
//    {
//
//    // Regular expressions used for validation
//        private static let nameRegex = "^[a-zA-Z ',.-]{3,20}$"
//        private static let usernameRegex = "^(?=.{6,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
//        private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//        private static let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}|:<>?]).{8,}$"
//
//        // Validation function for a name (first name or last name)
//        static func validateName(_ name: String) -> Bool
//        {
//            let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
//            return namePredicate.evaluate(with: name)
//        }
//        
//        static func validateEmail(_ email: String) -> Bool
//        {
//            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
//            return emailPredicate.evaluate(with: email)
//        }
//        
//        static func passwordsMatch(_ password1: String, _ password2: String) -> Bool {
//            return validatePassword(password1) && password1 == password2
//        }
//        
//        static func validateMajor(_ major: String, majorOptions: [String]) -> Bool {
//            return majorOptions.contains(major)
//        }
//        
//        static func validateYear(_ year: String, yearOptions: [String]) -> Bool {
//            return yearOptions.contains(year)
//        }
//
//        static func validateThisYear(_ thisYear: String, thisYearOptions: [String]) -> Bool {
//            return thisYearOptions.contains(thisYear)
//        }
//        
//        static func validateOrigin(_ origin: String, originOptions: [String]) -> Bool {
//            return originOptions.contains(origin)
//        }
//
//        static func validateEthnicity(_ ethnicity: String, ethnicityOptions: [String]) -> Bool {
//            return ethnicityOptions.contains(ethnicity)
//        }
//        
//        static func validateGender(_ gender: String, genderOptions: [String]) -> Bool {
//            return genderOptions.contains(gender)
//        }
//        
//        static func validatePassword(_ password: String) -> Bool {
//            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
//            return passwordPredicate.evaluate(with: password)
//        }
//
//
//        // Add other validation functions here following the same pattern
//    }
//
//    @Published var firstnameInput: String = ""
//    @Published var lastnameInput: String = ""
//    @Published var usernameInput: String = ""
//    @Published var passwordInput: String = ""
//    @Published var emailInput: String = ""
//    @Published var passwordConfirmInput: String = ""
//    @Published var majorInput: String = ""
//    @Published var yearInput: String = ""
//    @Published var thisYearInput: String = ""
//    @Published var originInput: String = ""
//    @Published var ethnicityInput: String = ""
//    @Published var genderInput: String = ""
//    
//    //data validation bools
//    @Published var isFirstNameValid = false
//    @Published var isLastNameValid = false
//    @Published var isUsernameValid = false
//    @Published var isEmailValid = false
//    @Published var isPasswordValid = false
//    @Published var isPasswordConfirmValid = false
//    @Published var isMajorValid = false
//    @Published var isYearValid = false
//    @Published var isThisYearValid = false
//    @Published var isOriginValid = false
//    @Published var isEthnicityValid = false
//    @Published var isGenderValid = false
//    @Published var isConfirmPasswordValid = false
//    
//    @Published var selectedYearIndex: Int = 0
//    @Published var selectedThisYearIndex: Int = 0
//
//
//    
//    @Published var showConfirmationView = false
//
//    let originOptions = Locale.countryNames // Use the country names from the extension
//    
//    @Published  var selectedMajorIndex = 0
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
//}
