import Foundation

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
                if let username = data["username"] as? String {
                    self.shpeito.username = username
                    print("Success")
                } else {
                    print("Incorrect data")
                }
            } else {
                print(data["error"] as Any)
            }
        }
    }


    
    // Method to get username
    func getUsername() -> String {
        return self.shpeito.username
    }
}

