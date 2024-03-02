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
    @State var classYearInput: String
    @State var gradYearInput: String
    @State var originInput: String
    @State var ethnicityInput: String
    @State var genderInput: String

    // Initializer
    init(id: String, name: String, points: Int,
         firstnameInput: String, lastnameInput: String, usernameInput: String, passwordInput: String,
         emailInput: String, passwordConfirmInput: String, majorInput: String, classYearInput: String,
         gradYearInput: String, originInput: String, ethnicityInput: String, genderInput: String,
         isConfirmPasswordValid: Bool) 
    {
        
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
        self.classYearInput = classYearInput
        self.gradYearInput = gradYearInput
        self.originInput = originInput
        self.ethnicityInput = ethnicityInput
        self.genderInput = genderInput
    }

   
}
