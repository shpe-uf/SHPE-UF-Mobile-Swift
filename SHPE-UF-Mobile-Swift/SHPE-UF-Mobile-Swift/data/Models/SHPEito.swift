import Foundation
import SwiftUI

class SHPEito
{
    // Attributes
    let id: String
    @Published var name: String
    @Published var points: Int
    
    // Additional attributes added
    @State var firstnameInput: String
    @State var lastnameInput: String
    @State var usernameInput: String
    @State var passwordInput: String
    @State var emailInput: String
    @State var passwordConfirmInput: String
    @State var majorInput: String
    @State var yearInput: String
    @State var thisYearInput: String
    @State var originInput: String
    @State var ethnicityInput: String
    @State var genderInput: String
    
    // Data validation bools
    @State var isFirstNameValid: Bool
    @State var isLastNameValid: Bool
    @State var isUsernameValid: Bool
    @State var isEmailValid: Bool
    @State var isPasswordValid: Bool
    @State var isPasswordConfirmValid: Bool
    @State var isMajorValid: Bool
    @State var isYearValid: Bool
    @State var isThisYearValid: Bool
    @State var isOriginValid: Bool
    @State var isEthnicityValid: Bool
    @State var isGenderValid: Bool
    @State var isConfirmPasswordValid: Bool

    // Initializer
    init(id: String, name: String, points: Int,
         firstnameInput: String, lastnameInput: String, usernameInput: String, passwordInput: String,
         emailInput: String, passwordConfirmInput: String, majorInput: String, yearInput: String,
         thisYearInput: String, originInput: String, ethnicityInput: String, genderInput: String,
         isFirstNameValid: Bool, isLastNameValid: Bool, isUsernameValid: Bool, isEmailValid: Bool,
         isPasswordValid: Bool, isPasswordConfirmValid: Bool, isMajorValid: Bool, isYearValid: Bool,
         isThisYearValid: Bool, isOriginValid: Bool, isEthnicityValid: Bool, isGenderValid: Bool,
         isConfirmPasswordValid: Bool) {
        
        self.id = id
        self.name = name
        self.points = points
        
        // Assigning additional attributes
        self.firstnameInput = firstnameInput
        self.lastnameInput = lastnameInput
        self.usernameInput = usernameInput
        self.passwordInput = passwordInput
        self.emailInput = emailInput
        self.passwordConfirmInput = passwordConfirmInput
        self.majorInput = majorInput
        self.yearInput = yearInput
        self.thisYearInput = thisYearInput
        self.originInput = originInput
        self.ethnicityInput = ethnicityInput
        self.genderInput = genderInput
        
        // Assigning data validation bools
        self.isFirstNameValid = isFirstNameValid
        self.isLastNameValid = isLastNameValid
        self.isUsernameValid = isUsernameValid
        self.isEmailValid = isEmailValid
        self.isPasswordValid = isPasswordValid
        self.isPasswordConfirmValid = isPasswordConfirmValid
        self.isMajorValid = isMajorValid
        self.isYearValid = isYearValid
        self.isThisYearValid = isThisYearValid
        self.isOriginValid = isOriginValid
        self.isEthnicityValid = isEthnicityValid
        self.isGenderValid = isGenderValid
        self.isConfirmPasswordValid = isConfirmPasswordValid
    }

   
}
