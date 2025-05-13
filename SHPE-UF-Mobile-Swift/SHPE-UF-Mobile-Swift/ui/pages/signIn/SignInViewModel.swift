import Foundation
import SwiftUI
import CoreData

final class SignInViewModel: ObservableObject
{
    // Private variables like the Apollo endpoint
    private var requestHandler = RequestHandler()
    
    // Out of View variables (Models)
    @Published var shpeito: SHPEito
    @Published var viewPassword: Bool = false
    @Published var error: String = "" // Error message variable
    @Environment(\.colorScheme) var colorScheme
    
    //Toast duration
    @Published var toastDuration = 3.0
    
    // Indicator for ongoing communication
    @Published var isCommunicating: Bool = false

    // Initialize SignInViewModel
    init(shpeito: SHPEito) {
        self.shpeito = shpeito
        self.username = shpeito.username
        self.password = shpeito.password
        self.remember = shpeito.remember
        self.firstName = shpeito.firstName
        self.lastName=shpeito.lastName
        self.year=shpeito.year
        self.major=shpeito.major
        self.id=shpeito.id
        self.token=shpeito.token
        self.confirmed=shpeito.confirmed
        self.updatedAt=shpeito.updatedAt
        self.createdAt=shpeito.createdAt
        self.email=shpeito.email
        self.fallPoints=shpeito.fallPoints
        self.summerPoints=shpeito.summerPoints
        self.springPoints=shpeito.springPoints
        //self.events=shpeito.events
       
    }
    
    // In View variables (What is being DISPLAYED & What is being INTERACTED WITH)
    @Published var signInButtonClicked: Bool = false
    @Published var username: String
    @Published var password: String
    @Published var remember: String
    @Published var firstName: String
    @Published var lastName: String
    @Published var year: String
    @Published var major: String
    @Published var id: String
    @Published var token: String
    @Published var confirmed: Bool
    @Published var updatedAt: String
    @Published var createdAt: String
    @Published var email: String
    @Published var fallPoints: Int
    @Published var springPoints: Int
    @Published var summerPoints: Int
    //@Published var events: SHPESchema.SignInMutation
    //store all of this to model
    // SignInMutation <= SignIn.graphql
    // Input: username: String, password: String
    // Successful Output: [
    //    "firstName": String,
    //    "lastName": String,
    //    "year": String,
    //    "major": String,
    //    "id": String,
    //    "token": String,
    //    "confirmed": Bool,
    //    "updatedAt": String,
    //    "createdAt": String,
    //    "email": String,
    //    "username": String,
    //    "fallPoints": Int,
    //    "springPoints": Int,
    //    "summerPoints": Int,
    //    "photo": String, => You may want to turn this into a Swift URL type by doing this => URL(string: <photo>)
    //    "events": [SHPESchema.SignInMutation...Event]
    //]
    
    func forgotPassword(email: String) {
        self.isCommunicating = true
        print("🔍 Starting email validation for: \(email)")
        requestHandler.validateEmail(email: email, completion: { result in
            DispatchQueue.main.async {
                if let error = result["error"] as? String {
                    self.isCommunicating = false
                    self.error = error
                    AppViewModel.appVM.toastMessage = self.error
                    withAnimation(.easeIn(duration: 0.3)) {
                        AppViewModel.appVM.showToast = true
                    }
                    
                    print("❌ Email validation failed with error: \(error)")
                    return
                }
                
                guard let emailExists = result["emailExists"] as? Bool, emailExists else {
                    self.isCommunicating = false
                    self.error = "Email not registered"
                    AppViewModel.appVM.toastMessage = self.error
                    withAnimation(.easeIn(duration: 0.3)) {
                        AppViewModel.appVM.showToast = true
                    }
                    print("⚠️ Email not registered: \(email)")
                    return
                }
                // Email exists, now proceed to request a password reset\\
                print("✅ Email exists. Proceeding to send password reset request...")
                self.requestHandler.forgotPassword(email: email) { data in
                    DispatchQueue.main.async {
                        self.isCommunicating = false
                        if let error = data["error"] as? String {
                            self.error = error
                            AppViewModel.appVM.toastMessage = self.error
                            withAnimation(.easeIn(duration: 0.3)) {
                                AppViewModel.appVM.showToast = true
                            }
                            print("❌ Failed to send password reset email: \(error)")
                            return
                        }
                        if let message = data["message"] as? String {
                            AppViewModel.appVM.toastMessage = message
                            withAnimation(.easeIn(duration: 0.3)) {
                                AppViewModel.appVM.showToast = true
                            }
                            print("📬 Password reset request successful. Message: \(message)")

                            // Optionally, handle the reset token if needed:
                            // if let token = data["token"] as? String {
                            //     // Navigate to reset password screen or store token
                            // }
                        }
                        else{
                            print("⚠️ Password reset response missing 'message' field.")

                        }
                    }
                }
            }
        })
    }

//    func ComposeEmail(email: String, completion: @escaping ([String: Any]) -> Void) {
//        self.isCommunicating = true
//        
//        // 1. Get the user’s name for the given email
//        requestHandler.usersName(email: email) { result in
//            
//            // Check if usersName returned an error
//            if let error = result["error"] as? String {
//                self.isCommunicating = false
//                completion(["error": error])
//                return
//            }
//            
//            // Extract the user's name
//            guard let userName = result["name"] as? String else {
//                self.isCommunicating = false
//                completion(["error": "No name found for this email"])
//                return
//            }
//            
//            // 2. Compose & send the email
//            self.requestHandler.ComposeForgetEmail(recipient: email, name: userName) { emailResult in
//                // 3. Once done, stop the spinner and call completion
//                DispatchQueue.main.async{
//                    self.isCommunicating = false
//                }
//                completion(emailResult)
//            }
//        }
//    }

    // Methods to call in View
    func signIn(username: String, password: String, viewContext:NSManagedObjectContext) {
        // Set the username and password to the SHPEito model
        self.shpeito.username = username
        self.shpeito.password = password
        
        // Toggle indicator to show ongoing communication
        self.isCommunicating = true
        
        
        
        
        
        requestHandler.signIn(username: username, password: password) { data in
            
            // Toggle indicator to hide ongoing communication
            self.isCommunicating = false
        
            
            // Check that no error was detected
            if let error = data["error"] as? String {
                // Handle different error types
                switch error
                {
                    case "Wrong credentials.":
                        self.error = "Incorrect username or password."
                    case "User not found.":
                        self.error = "User account not found."
                    case "Network Error":
                        self.error = "Could not establish a connection to server. Try again later."
                    case "Errors":
                        if username.isEmpty || password.isEmpty {
                            self.error = "Missing username and/or password."
                        }
                        else{
                            self.error = "Unexpected error occurred. Try again later."
                            }
                    default:
                        self.error = "Unexpected error occurred. Try again later."
                }
                
                AppViewModel.appVM.toastMessage = self.error
                withAnimation(.easeIn(duration: 0.3))
                {
                    AppViewModel.appVM.showToast = true
                }
                
                    
                return print(self.error)
            } else {
                self.isCommunicating = true
                // Process successful sign-in
                if let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String,
                   let year = data["year"] as? String,
                   let major = data["major"] as? String,
                   let id = data["id"] as? String,
                   let token = data["token"] as? String,
                   let confirmed = data["confirmed"] as? Bool,
                   let updatedAt = data["updatedAt"] as? String,
                   let createdAt = data["createdAt"] as? String,
                   let email = data["email"] as? String,
                   let username = data["username"] as? String,
                   let gender = data["gender"] as? String,
                   let ethnicity = data["ethnicity"] as? String,
                   let originCountry = data["originCountry"] as? String,
                   let graduationYear = data["graduationYear"] as? String,
                   let classes = data["classes"] as? [String],
                   let internships = data["internships"] as? [String],
                   let links = data["links"] as? [String],
                   let photo = data["photo"] as? String
                {
                    let prefixToRemove = "data:image/jpeg;base64,"
                    let base64StringPhoto = photo.replacingOccurrences(of: prefixToRemove, with: "")
                    //TODO: Finish adding fields to the SHPEito
                    self.shpeito = SHPEito(username: username, password: password, remember: "True", base64StringPhoto: base64StringPhoto, firstName: firstName, lastName: lastName, year: year, major: major, id: id, token: token, confirmed: confirmed, updatedAt: updatedAt, createdAt: createdAt, email: email, gender: gender, ethnicity: ethnicity, originCountry: originCountry, graduationYear: graduationYear, classes: classes, internships: internships, links: links, fallPoints: 0, summerPoints: 0, springPoints: 0, points: 0, fallPercentile: 0, springPercentile: 0, summerPercentile: 0)

                    
                    // Store user in core memory
                    self.addUserItemToCore(viewContext: viewContext)
                    
                    AppViewModel.appVM.setPageIndex(index: 2)
                    AppViewModel.appVM.shpeito = self.shpeito
                }
            }
        }
    }
    
    private func addUserItemToCore(viewContext:NSManagedObjectContext)
    {
        let user = User(context: viewContext)
        user.username = shpeito.username
        user.photo = shpeito.profileImage?.jpegData(compressionQuality: 0.0)
        user.firstName = shpeito.firstName
        user.lastName = shpeito.lastName
        user.year = shpeito.year
        user.major = shpeito.major
        user.id = shpeito.id
        user.token = shpeito.token
        user.confirmed = shpeito.confirmed
        user.updatedAt = shpeito.updatedAt
        user.createdAt = shpeito.createdAt
        user.loginTime = Date()
        user.email = shpeito.email
        
        user.ethnicity = shpeito.ethnicity
        user.gender = shpeito.gender
        user.country = shpeito.originCountry
        user.graduating = shpeito.graduationYear
        user.classes = shpeito.classes as NSObject
        user.internships = shpeito.internships as NSObject
        user.links = shpeito.absoluteStringsOfLinks() as NSObject
        
        user.fallPoints = Int64(shpeito.fallPoints)
        user.summerPoints = Int64(shpeito.summerPoints)
        user.springPoints = Int64(shpeito.springPoints)
        user.points = Int64(shpeito.points)
        user.fallPercentile = Int64(shpeito.fallPercentile)
        user.springPercentile = Int64(shpeito.springPercentile)
        user.summerPercentile = Int64(shpeito.summerPercentile)
        user.darkMode = AppViewModel.appVM.darkMode
        print("✅✅✅")
        
        do { try viewContext.save() } catch { print("Could not save user to Core❌") }
    }

    // Add this function to Profile View Model for sign out function
    func deleteUserItemToCore(viewContext: NSManagedObjectContext, user: User) {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not delete user from Core") }
    }
}
