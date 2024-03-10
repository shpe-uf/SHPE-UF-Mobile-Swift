import Foundation
import CoreData

final class SignInViewModel: ObservableObject {
    // Private variables like the Apollo endpoint
    private var requestHandler = RequestHandler()
    
    // Out of View variables (Models)
    @Published var shpeito: SHPEito
    @Published var viewPassword: Bool = false
    
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
        self.photoURL = shpeito.photoURL
        //self.events=shpeito.events
        
        // Any setup steps you need...
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
    @Published var photoURL: URL?
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
    func signIn(username: String, password: String) {
        // Set the username and password to the SHPEito model
        self.shpeito.username = username
        self.shpeito.password = password
        
        requestHandler.signIn(username: username, password: password) { data in
            // Check that no error was detected
            if data["error"] == nil {
                // Check if all the data is there and is the correct Type
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
                   let fallPoints = data["fallPoints"] as? Int,
                   let springPoints = data["springPoints"] as? Int,
                   let summerPoints = data["summerPoints"] as? Int,
                   let photo = data["photo"] as? String
                {
                    //TODO: Finish adding fields to the SHPEito
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
                    
                    AppViewModel.appVM.setPageIndex(index: 1)
                    AppViewModel.appVM.shpeito = self.shpeito
                } else {
                    // Needs to be handled
                    self.signInButtonClicked = false
                    print("Incorrect data")
                }
            } else {
                self.signInButtonClicked = false
                print(data["error"] as Any)
            }
        }
    }
    
    private func addUserItemToCore(viewContext:NSManagedObjectContext)
    {
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
    func deleteUserItemToCore(viewContext:NSManagedObjectContext, user:User)
    {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }


    
    // Method to get username
    func getUsername() -> String {
        return self.shpeito.username
    }
}

