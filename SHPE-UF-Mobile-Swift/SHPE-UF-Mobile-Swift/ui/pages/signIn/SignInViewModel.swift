//
//  SignInViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation
import CoreData
import SwiftUI
//sample structure for authentication
class AuthService {
    // Function to authenticate a user
    static func authenticateUser(username: String, password: String, completion: @escaping (Result<UserData, AuthError>) -> Void) {
        // simulate an asynchronous authentication process
        DispatchQueue.global().async {
            // authentication logic
            // make a network request to your MongoDB Realm authentication API
            // example
            if username == "demo" && password == "password" {
                // successful authentication
                let userData = UserData(firstName: "David", lastName: "Vera", isConfirmed: true)
                completion(.success(userData))
            } else {
                // authentication failed
                completion(.failure(.authenticationFailed))
            }
        }
    }
}

struct UserData {
    let firstName: String
    let lastName: String
    let isConfirmed: Bool
}

enum AuthError: Error {
    // enum cases for authentication errors
    case authenticationFailed
    // add more case errors if needed
}

final class SignInViewModel: ObservableObject {
    @Published var usernameInput: String = ""
    @Published var passwordInput: String = ""
    @Published var userInCore: Bool = false
    @Published var register: Bool = false
    
    // user sign-in
    func signIn(viewContext: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        // authenticate user with MongoDB
        AuthService.authenticateUser(username: usernameInput, password: passwordInput) { result in
            switch result {
            case .success(let userData):
                // retrieve user data
                // check that user is confirmed (Has responded to confirmation email)
                guard userData.isConfirmed else {
                    // case where the user is not confirmed
                    completion(false)
                    return
                }

                // create new user object (assuming User is a MongoDB Realm entity)
                let newUser = User(context: viewContext)
                newUser.firstName = userData.firstName
                newUser.lastName = userData.lastName

                // clear core mem
                self.clearCoreMemory(viewContext: viewContext)

                // add new user object to MongoDB Realm
                // (integrate with MongoDB)
                // sample- realmApp.currentUser()?.functions.addUser(newUser)

                do {
                    try viewContext.save()
                    // return true to indicate a successful sign-in
                    completion(true)
                } catch {
                    // saving to core fails case
                    print("Could not save to Core: \(error)")
                    completion(false)
                }

            case .failure(let error):
                // authentication fails
                print("Authentication failed with error: \(error)")
                completion(false)
            }
        }
    }
    
    // Username validation
    func isUsernameValid() -> Bool {
        // username validation: non-empty and at least 3 characters
        return !usernameInput.isEmpty && usernameInput.count >= 3
    }

    // Password validation
    func isPasswordValid() -> Bool {
        // password validation: non-empty and at least 8 characters
        return !passwordInput.isEmpty && passwordInput.count >= 8
    }

    // Alert handling
    func showValidationAlert() {
        if isUsernameValid() && isPasswordValid() {
            // sign-in logic
            print("Finding you in our system...")
        } else {
            // validation alert with specific messages
            if usernameInput.isEmpty && passwordInput.isEmpty {
                showAlert("Validation Error", "Username is required.\nPassword is required.")
            } else {
                showAlert("Validation Error", "Invalid username or password.")
            }
        }
    }
    
    func createSHPEito() {
        // Implementation related to MongoDB Realm might go here
    }
    
    // MARK: DEV Functions
    
    // Add a sample user to Core Data
    func addUserItemToCore(viewContext: NSManagedObjectContext) {
        let user = User(context: viewContext)
        user.firstName = "Daniel"
        user.lastName = "Parra"
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
    
    // Delete a user from Core Data
    func deleteUserItemToCore(viewContext: NSManagedObjectContext, user: User) {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
    
    // Show an alert with a title and message
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      
        // Present the alert to the user
        // Example: present(alert, animated: true, completion: nil)
    }
    
    // Clear Core Data memory structure
    private func clearCoreMemory(viewContext: NSManagedObjectContext) {
        // work on logic to clear Core Data memory
        // (e.g., delete all User entities)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
        } catch {
            print("Error deleting core data entities: \(error)")
        }
    }
}

