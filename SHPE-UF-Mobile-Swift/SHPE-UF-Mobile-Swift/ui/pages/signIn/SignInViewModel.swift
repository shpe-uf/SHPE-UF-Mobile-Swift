
import Foundation

final class SignInViewModel: ObservableObject {
    // Private variables like the Apollo endpoint
    private var requestHandler = RequestHandler()
    
    // Out of View variables (Models)
    @Published var shpeito: SHPEito
    
    // Initialize SignInViewModel
    init(shpeito: SHPEito) {
        self.shpeito = shpeito
        self.username = shpeito.username
        self.password = shpeito.password
        
        // Any setup steps you need...
    }
    
    // In View variables (What is being DISPLAYED & What is being INTERACTED WITH)
    @Published var signInButtonClicked: Bool = false
    @Published var username: String
    @Published var password: String
    
    
    // Methods to call in View
    func signIn() {
        requestHandler.signIn(username: self.username, password: self.password) { data in
            // Check that no error was detected
            if data["error"] == nil {
                // Check if all the data is there and is the correct Type
                if let username = data["username"] as? String,
                   let password = data["password"] as? String
                {
                    print("Success")
                    self.shpeito.username = username
                    self.shpeito.password = password
                }
                else{
                    print("Incorrect data")
                }
                
            }
            else{
                print(data["error"])
            }
        }
    }
    
    // Method to get username
    func getUsername() -> String {
        return self.shpeito.username
    }
}

