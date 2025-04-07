import Foundation
import SwiftUI
import UIKit
import Combine

//foundation framework of all the countries of the world
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
/// A view model that manages the entire user registration process across multiple screens.
///
/// `RegisterViewModel` handles all business logic for the three-step registration flow, including:
/// - Form input data collection and storage
/// - Field validation and error handling
/// - API communication for account creation
/// - Navigation between registration steps
///
/// The view model maintains state for all registration fields across the different views,
/// allowing users to navigate between steps while preserving their input data.
@MainActor
class RegisterViewModel: ObservableObject
{
    private let requestHandler = RequestHandler()
    
    init () {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        var yearsList: [String] = ["Select"]
        for i in 0..<5 {
            let year = String(currentYear + i)
            yearsList.append(year)
        }
        
        self.gradYearOptions = yearsList
    }
    
    //field inputs
    @Published var firstnameInput: String = ""
    @Published var lastnameInput: String = ""
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var emailInput: String = ""
    @Published var passwordConfirmInput: String = ""
    @Published var majorInput: String = "Select"
    @Published var classYearInput: String = "Select"
    @Published var gradYearInput: String = "Select"
    @Published var originInput: String = "Select"
    @Published var ethnicityInput: String = "Select"
    @Published var genderInput: String = "Select"
    
    //picker indexes
    @Published var selectedMajorIndex: Int = 0
    @Published var selectedYearIndex: Int = 0
    @Published var selectedThisYearIndex: Int = 0
    @Published var selectedOriginIndex: Int? = 0

    //reveal password and confirm password bools
    @Published var viewPassword:Bool = false
    @Published var viewConfirmPassword:Bool = false
    
    //index to inc or dec for view
    @Published var viewIndex:Int = 0
    
    //controls the visibility of the toast
    @Published var showToast = false
    
    @Published var userNameExists = ""
    @Published var emailExists = ""
    
    @Published var loading:Bool = false
    @Published var onLastPage:Bool = false
    //validation bool for checking user input after hitting return, giving them the correction warning
    @Published var emailValidated = false
    @Published var usernameValidated = false
    @Published var passwordValidated = false
    @Published var firstNameValidated = false
    @Published var lastNameValidated = false
    @Published var genderPickerInteracted = false
    @Published var ethnicityPickerInteracted = false
    @Published var originPickerInteracted = false
    @Published var majorPickerInteracted = false
    @Published var classYearPickerInteracted = false
    @Published var gradYearPickerInteracted = false
    
    //major options
    //keep the spaces in the string,
    //it's a loophole for the calculatePickerHeight function to work for some specific picker options
    let majorOptions =
    [
        "Select",
        "Aerospace Engineering              ",
        "Agricultural Engineering             ",
        "Biomedical Engineering           ",
        "Chemical Engineering",
        "Civil Engineering",
        "Oceanographic Engineering         ",
        "Computer Engineering",
        "Computer Science",
        "Digital Arts & Sciences        ",
        "Electrical Engineering",
        "Environmental Engineering       ",
        "Human-Centered Computing            ",
        "Industrial & Systems Engineering",
        "Materials Science & Engineering",
        "Mechanical Engineering           ",
        "Nuclear Engineering",
        "Other"
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
    var gradYearOptions:[String] = []
    
    //ethncity options
    //keep the spaces in the string,
    //it's a loophole for the calculatePickerHeight function to work for some specific picker options
    let ethnicityOptions =
    [
        "Select",
        "American Indian or Alaska Native",
        "Asian",
        "Black or African American        ",
        "Hispanic/Latino",
        "Native Hawaiian or Other Pacific Islander",
        "White",
        "Two or more ethnicities       ",
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
    let originOptions = ["Select"] + Locale.countryNames

    // MARK: - Helper Methods
    
    /// Calculates the appropriate height for dropdown pickers based on content.
    ///
    /// - Parameters:
    ///   - option: The selected option text
    ///   - maxWidth: The maximum width available for the picker
    ///   - fontSize: The font size used in the picker
    /// - Returns: The calculated height needed for the picker
    func calculatePickerHeight(for option: String, maxWidth: CGFloat, fontSize: CGFloat) -> CGFloat 
    {
        let charPerLine = maxWidth / (fontSize * 0.6) //estimate chars per line, adjust 0.6 based on font
        let linesNeeded = ceil(CGFloat(option.count) / charPerLine)
        let lineHeight = fontSize * 1.2 //adjust based on font and line spacing

        //dynamic padding adjustment
        let basePadding: CGFloat = 20 //minimum padding
        let additionalPaddingPerLine: CGFloat = 15 //additional padding for each line needed
        let dynamicPadding = basePadding + (additionalPaddingPerLine * (linesNeeded - 1))

        let calculatedHeight = linesNeeded * lineHeight + dynamicPadding //add dynamic padding
        let minHeight: CGFloat = 37.64706 //minimum height so they all match

        return max(calculatedHeight, minHeight) //return the larger of the calculated height or the minimum height
    }
    
    // MARK: - Validation Methods
    
    /// Validates the email format, ensuring it's from UFL or SF College.
    ///
    /// - Returns: `true` if the email is valid, `false` otherwise
    func validateEmail() -> Bool
    {
        let emailPattern = "^[\\w.-]+@(ufl\\.edu|sfcollege\\.edu)$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES[c] %@", emailPattern)
        return emailPredicate.evaluate(with: emailInput)
    }
    
    /// Validates the username format (6-20 alphanumeric characters, periods, underscores).
    ///
    /// - Returns: `true` if the username is valid, `false` otherwise
    func validateUsername() -> Bool
    {
        let usernamePattern = "^[\\w.]{6,20}$"
        let usernamePredicate = NSPredicate(format:"SELF MATCHES %@", usernamePattern)
        return usernamePredicate.evaluate(with: usernameInput)
    }
    /// Checks if the provided username and email are available.
    ///
    /// Makes an API call to verify the availability of the username and email.
    /// If both are available, advances to the next registration step.
    func validateUsernameAndEmail()
    {
        requestHandler.validateUsernameAndEmail(username: usernameInput, email: emailInput) { [self] dict in
            if dict["error"] == nil,
               let userBool = dict["usernameExists"] as? Bool,
               let emailBool = dict["emailExists"] as? Bool
            {
                userNameExists = userBool ? "This username already exists." : ""
                emailExists = emailBool ? "An account with this email already exists." : ""
                
                if !userBool && !emailBool
                {
                    viewIndex = 1
                }
            }
            else
            {
                userNameExists = "Could not connect to server, try again later..."
                emailExists = "Could not connect to server, try again later..."
            }
            loading = false
        }
    }

    /// Validates the password meets security requirements.
    ///
    /// Checks for minimum length (8), uppercase, lowercase, number, and special character.
    ///
    /// - Returns: `true` if the password is valid, `false` otherwise
    func validatePassword() -> Bool
    {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-={}|;:'\",.<>?~`])[\\S]{8,}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordPattern)
        return passwordPredicate.evaluate(with: passwordInput)
    }

    /// Validates if the confirm password matches the password.
    ///
    /// - Returns: `true` if passwords match, `false` otherwise
    func validateConfirmPassword() -> Bool
    {
        return passwordInput == passwordConfirmInput
    }

    /// Validates all required fields in the first registration screen.
    ///
    /// - Returns: `true` if all fields are valid, `false` otherwise
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

    /// Validates all required fields in the personal information screen.
    ///
    /// - Returns: `true` if all fields are valid, `false` otherwise
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
    
    /// Validates all required fields in the academic information screen.
    ///
    /// - Returns: `true` if all fields are valid, `false` otherwise
    func isAcademicValid() -> Bool
    {
        return validateMajorSelected() && validateClassYearSelected() && validateGradYearSelected()
    }
    
    // MARK: - API Interaction
    
    /// Submits the registration data to create a new user account.
    ///
    /// Called when all validation has passed and the user completes the final registration step.
    /// Makes an API call to create the account with all collected information.
    func registerUser()
    {
        requestHandler.registerUser(firstName: firstnameInput, lastName: lastnameInput, major: majorInput, year: classYearInput, graduating: gradYearInput, country: originInput, ethnicity: ethnicityInput, sex: genderInput, username: usernameInput, email: emailInput, password: passwordInput, confirmPassword: passwordConfirmInput)
        { 
            dict in if dict["error"] != nil
            {
                print("Error occurred during registration")
                    return
            }
        }
    }
    
}
