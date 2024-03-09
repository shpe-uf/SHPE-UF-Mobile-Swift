import Foundation
import SwiftUI
import UIKit
import Combine

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


@MainActor
class RegisterViewModel: ObservableObject
{
    
    private let requestHandler = RequestHandler()
    
    //inputs
    @Published var firstnameInput: String = ""
    @Published var lastnameInput: String = ""
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var emailInput: String = ""
    @Published var passwordConfirmInput: String = ""
    @Published var majorInput: String = ""
    @Published var classYearInput: String = ""
    @Published var gradYearInput: String = ""
    @Published var originInput: String = ""
    @Published var ethnicityInput: String = ""
    @Published var genderInput: String = ""
    
    //picker indexs
    @Published var selectedMajorIndex: Int = 0
    @Published var selectedYearIndex: Int = 0
    @Published var selectedThisYearIndex: Int = 0
    @Published var selectedOriginIndex: Int? = nil // Optional if no initial selection

    
    @Published var viewPassword:Bool = false
    @Published var viewConfirmPassword:Bool = false
    @Published var viewIndex:Int = 0
    {
        didSet
        {
            print("New Index \(viewIndex)")
        }
    }
    
    //nav bools
    @Published var shouldNavigate: Bool = false
    @Published var shouldNavigate1: Bool = false
    @Published var shouldNavigate2: Bool = false
    
    // Controls the visibility of the toast
    @Published var showToast = false
    
    //major options
    let majorOptions =
    [
        "Select",
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
    
    //year options
    let classYearOptions =
    [
        "Select",
        "1st Year",
        "2nd Year",
        "3rd Year",
        "4th Year",
        "5th Year or Higher",
        "Graduate",
        "Ph.D."
    ]
    
    //graduation year options
    let gradYearOptions =
    [
        "Select",
        "Not Graduating",
        "Fall Semester",
        "Spring Semester",
        "Summer Semester"
    ]
    
    //ethncity options
    let ethnicityOptions =
    [
        "Select",
        "American Indian or Alaska Native",
        "Asian",
        "Black or African American",
        "Hispanic/Latino",
        "Native Hawaiian or Other Pacific Islander",
        "White",
        "Two or more ethnicities",
        "Prefer not to answer"
    ]
    
    //gender options
    let genderOptions =
    [
        "Select",
        "Male",
        "Female",
        "Non-Binary",
        "Other",
        "Prefer not to answer"
    ]
    
    //origin options from locale
    let originOptions = Locale.countryNames
    
    //VALIDATION SECTION
    
    //validate email
    func validateEmail() -> Bool
    {
        let emailPattern = "^[\\w.-]+@(ufl\\.edu|sfcollege\\.edu)$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES[c] %@", emailPattern)
        return emailPredicate.evaluate(with: emailInput)
    }
    
    //validate username
    func validateUsername() -> Bool
    {
        let usernamePattern = "^[\\w.]{6,20}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernamePattern)
        return usernamePredicate.evaluate(with: usernameInput)
    }

    //validate password
    func validatePassword() -> Bool
    {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}|;:'\",.<>?~`])[\\S]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordPattern)
        return passwordPredicate.evaluate(with: passwordInput)
    }

    //validate password matching
    func validateConfirmPassword() -> Bool
    {
        return passwordInput == passwordConfirmInput
    }

    //validate all inputs on registerView
    func isRegisterValid() -> Bool
    {
           return validateEmail() && validatePassword() && validateConfirmPassword() && validateUsername()
    }

    //validate firstname
    func validateFirstName() -> Bool
    {
        let namePattern = "^[A-Za-z]{3,20}$"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", namePattern)
        return namePredicate.evaluate(with: firstnameInput)
    }

    //validate lastname
    func validateLastName() -> Bool
    {
        let namePattern = "^[A-Za-z]{3,20}$"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", namePattern)
        return namePredicate.evaluate(with: lastnameInput)
    }

    //validate gender selection
    func validateGenderSelected() -> Bool
    {
        return genderInput != "" && genderInput != "Select"
    }

    //validate ethnicity selection
    func validateEthnicitySelected() -> Bool
    {
        return ethnicityInput != "" && ethnicityInput != "Select"
    }

    //validate origin selection
    func validateCountryOfOriginSelected() -> Bool
    {
        return originInput != "" && originInput != "Select"
    }

    //validate all inputs in personalDetailsView
    func isPersonalValid() -> Bool
    {
       return validateFirstName() && validateLastName() && validateGenderSelected() && validateEthnicitySelected() && validateCountryOfOriginSelected()
    }
    
    //validate major selection
    func validateMajorSelected() -> Bool
    {
        return majorInput != "" && majorInput != "Select"
    }

    //validate year selection
    func validateClassYearSelected() -> Bool
    {
        return classYearInput != "" && classYearInput != "Select"
    }

    //validate graduation year selection
    func validateGradYearSelected() -> Bool
    {
        return gradYearInput != "" && gradYearInput != "Select"
    }
    
    //validate all inputs in academicInfoView
    func isAcademicValid() -> Bool
    {
        return validateMajorSelected() && validateClassYearSelected() && validateGradYearSelected()
    }

    //register user
    func registerUser()
    {
        requestHandler.registerUser(firstName: firstnameInput, lastName: lastnameInput, major: majorInput, year: classYearInput, graduating: gradYearInput, country: originInput, ethnicity: ethnicityInput, sex: genderInput, username: usernameInput, email: emailInput, password: passwordInput, confirmPassword: passwordConfirmInput)
        { dict in if dict["error"] != nil
            {
                print("Error occurred during registration")
                    return
            }
        }
    }
    
}
