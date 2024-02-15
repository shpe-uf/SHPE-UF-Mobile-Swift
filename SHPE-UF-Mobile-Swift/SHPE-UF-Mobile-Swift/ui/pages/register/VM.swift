import Foundation
import SwiftUI
import UIKit

extension Locale
{
    static let countryNames: [String] =
    {
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes
        {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        return countries.sorted()
    }()
}

struct TransparentTextFieldStyle: TextFieldStyle
{
    func _body(configuration: TextField<Self._Label>) -> some View
    {
        configuration
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.gray, lineWidth: 1))
            .shadow(radius: 2)
    }
}

struct Validation
{

    private static let nameRegex = "^[a-zA-Z ',.-]{3,20}$"
    private static let usernameRegex = "^(?=.{6,20}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
    private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private static let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}|:<>?]).{8,}$"

    
    static func validateName(_ name: String) -> Bool
    {
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }

    static func validateEmail(_ email: String) -> Bool
    {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    static func validateUsername(_ username: String) -> Bool {
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePredicate.evaluate(with: username)
    }

    static func passwordsMatch(_ password1: String, _ password2: String) -> Bool {
        return validatePassword(password1) && password1 == password2
    }

    static func validateMajor(_ major: String, majorOptions: [String]) -> Bool {
        return majorOptions.contains(major)
    }

    static func validateYear(_ year: String, yearOptions: [String]) -> Bool {
        return yearOptions.contains(year)
    }

    static func validateThisYear(_ thisYear: String, thisYearOptions: [String]) -> Bool {
        return thisYearOptions.contains(thisYear)
    }

    static func validateOrigin(_ origin: String, originOptions: [String]) -> Bool {
        return originOptions.contains(origin)
    }

    static func validateEthnicity(_ ethnicity: String, ethnicityOptions: [String]) -> Bool {
        return ethnicityOptions.contains(ethnicity)
    }

    static func validateGender(_ gender: String, genderOptions: [String]) -> Bool {
        return genderOptions.contains(gender)
    }

    static func validatePassword(_ password: String) -> Bool {
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }

}

@MainActor
class RegisterViewModel: ObservableObject
{
    private let requestHandler = RequestHandler()
    
    @Published var firstnameInput: String = ""
    @Published var lastnameInput: String = ""
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var emailInput: String = ""
    @Published var passwordConfirmInput: String = ""
    @Published var majorInput: String = ""
    @Published var yearInput: String = ""
    @Published var thisYearInput: String = ""
    @Published var originInput: String = ""
    @Published var ethnicityInput: String = ""
    @Published var genderInput: String = ""
    
    @Published var isFirstNameValid = false
    @Published var isLastNameValid = false
    @Published var isUsernameValid = false
    @Published var isEmailValid = false
    @Published var isPasswordValid = false
    @Published var isPasswordConfirmValid = false
    @Published var isMajorValid = false
    @Published var isYearValid = false
    @Published var isThisYearValid = false
    @Published var isOriginValid = false
    @Published var isEthnicityValid = false
    @Published var isGenderValid = false
    
    @Published private var showConfirmationView = false
    
    @Published var selectedMajorIndex: Int = 0
    @Published var selectedYearIndex: Int = 0
    @Published var selectedThisYearIndex: Int = 0
    @Published var selectedOriginIndex: Int? = nil // Optional if no initial selection

    @Published var viewPassword:Bool = false
    @Published var viewConfirmPassword:Bool = false
    @Published var viewIndex:Int = 0
    
    
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
    ]
    
    let yearOptions = [
        "1st Year",
        "2nd Year",
        "3rd Year",
        "4th Year",
        "5th Year or Higher",
        "Graduate",
        "Ph.D."
    ]
    
    let thisYearOptions = [
        "Not Graduating",
        "Fall Semester",
        "Spring Semester",
        "Summer Semester"
    ]
    
    let originOptions = Locale.countryNames
    
    let ethnicityOptions = [
        "American Indian or Alaska Native",
        "Asian",
        "Black or African American",
        "Hispanic/Latino",
        "Native Hawaiian or Other Pacific Islander",
        "White",
        "Two or more ethnicities",
        "Prefer not to answer"
    ]
    
    let genderOptions = ["Male", "Female", "Non-Binary", "Other", "Prefer not to answer"]
    
   // func registerUser()
//    {
//        if validateAllFields()
//            {
//                requestHandler.registerUser(firstName: firstnameInput, lastName: lastnameInput, major: majorInput, year: yearInput, graduating: thisYearInput, country: originInput, ethnicity: ethnicityInput, sex: genderInput, username: usernameInput, email: emailInput, password: passwordInput, confirmPassword: passwordConfirmInput)
//                { dict in
//                    // Check if error is inside dict
//                    if dict["error"] != nil
//                    {
//                        print("")
//                        //change button, processing request try again maybe
//                        return
//                    }
//                    // If error not there
//                    showConfirmationView = true
//                }
//            }
//    }
    
    
    
    func registerUser() 
    {
        //guard validateAllFields() else { return }
        
        requestHandler.registerUser(firstName: firstnameInput, lastName: lastnameInput, major: majorInput, year: yearInput, graduating: thisYearInput, country: originInput, ethnicity: ethnicityInput, sex: genderInput, username: usernameInput, email: emailInput, password: passwordInput, confirmPassword: passwordConfirmInput) { dict in
            if dict["error"] != nil {
                print("Error occurred during registration")
                return
            }
            //showConfirmationView = true
        }
    }
    

    
//    func validateAllFields() -> Bool 
//    {
//        isFirstNameValid = Validation.validateName(firstnameInput)
//        isLastNameValid = Validation.validateName(lastnameInput)
//        isUsernameValid = Validation.validateUsername(usernameInput)
//        isEmailValid = Validation.validateEmail(emailInput)
//        isMajorValid = Validation.validateMajor(majorInput, majorOptions: majorOptions)
//        isYearValid = Validation.validateYear(yearInput, yearOptions: yearOptions)
//        isThisYearValid = Validation.validateThisYear(thisYearInput, thisYearOptions: thisYearOptions)
//        isOriginValid = Validation.validateOrigin(originInput, originOptions: originOptions)
//        isEthnicityValid = Validation.validateEthnicity(ethnicityInput, ethnicityOptions: ethnicityOptions)
//        isGenderValid = Validation.validateGender(genderInput, genderOptions: genderOptions)
//        isPasswordValid = Validation.validatePassword(passwordInput)
//        isPasswordConfirmValid = Validation.passwordsMatch(passwordInput, passwordConfirmInput)
//        
//        return isFirstNameValid && isLastNameValid && isUsernameValid && isEmailValid && isMajorValid && isYearValid && isThisYearValid && isOriginValid && isEthnicityValid && isGenderValid && isPasswordValid && isPasswordConfirmValid
//    }
}
