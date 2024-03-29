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
                switch error {
                                case "Wrong credentials.":
                                    self.error = "Incorrect username or password."
                                case "User not found.":
                                    self.error = "User account not found."
                                case "Network Error":
                                    self.error = "Could not connect to the backend."
                                case "Errors":
                                    if username.isEmpty || password.isEmpty {
                                        self.error = "Missing username and/or password."
                                    } 
                                    else{
                                        self.error = "Unexpected error occurred."
                                        }
                                default:
                                    self.error = "Unexpected error occurred."
                                }
                                return print(self.error)
            } else {
                self.isCommunicating = true
                if self.isCommunicating == true{
                    print("Is communicating.")
                }
                // Process successful sign-in
                if let userData = data["userData"] as? [String: Any] {
                    if let firstName = userData["firstName"] as? String,
                       let lastName = userData["lastName"] as? String,
                       let year = userData["year"] as? String,
                       let major = userData["major"] as? String,
                       let id = userData["id"] as? String,
                       let token = userData["token"] as? String,
                       let confirmed = userData["confirmed"] as? Bool,
                       let updatedAt = userData["updatedAt"] as? String,
                       let createdAt = userData["createdAt"] as? String,
                       let email = userData["email"] as? String,
                       let username = userData["username"] as? String,
                       let fallPoints = userData["fallPoints"] as? Int,
                       let springPoints = userData["springPoints"] as? Int,
                       let summerPoints = userData["summerPoints"] as? Int,
                       let photo = userData["photo"] as? String {
                        // Update SHPEito with user data
                        self.shpeito.firstName = firstName
                        self.shpeito.lastName = lastName
                        self.shpeito.year = year
                        self.shpeito.major = major
                        self.shpeito.id = id
                        self.shpeito.token = token
                        self.shpeito.confirmed = confirmed
                        self.shpeito.updatedAt = updatedAt
                        self.shpeito.createdAt = createdAt
                        self.shpeito.email = email
                        self.shpeito.username = username
                        self.shpeito.fallPoints = fallPoints
                        self.shpeito.springPoints = springPoints
                        self.shpeito.summerPoints = summerPoints
                        self.shpeito.photoURL = URL(string: photo)
                        
                        // Store user in core memory
                        self.addUserItemToCore(viewContext: viewContext)
                        
                        AppViewModel.appVM.setPageIndex(index: 2)
                        AppViewModel.appVM.shpeito = self.shpeito
                    }
                }
                print("Success")
                
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
        
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }

    // Add this function to Profile View Model for sign out function
    func deleteUserItemToCore(viewContext:NSManagedObjectContext, user:User)
    {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }


    
    private func addUserItemToCore(viewContext: NSManagedObjectContext) {
        let user = User(context: viewContext)
        user.username = shpeito.username
        user.photo = shpeito.photoURL?.absoluteString ?? ""
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
        user.fallPoints = Int64(shpeito.fallPoints)
        user.summerPoints = Int64(shpeito.summerPoints)
        user.springPoints = Int64(shpeito.springPoints)
        user.points = Int64(shpeito.points)
        user.fallPercentile = Int64(shpeito.fallPercentile)
        user.springPercentile = Int64(shpeito.springPercentile)
        user.summerPercentile = Int64(shpeito.summerPercentile)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }

    // Add this function to Profile View Model for sign out function
    func deleteUserItemToCore(viewContext: NSManagedObjectContext, user: User) {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
}
