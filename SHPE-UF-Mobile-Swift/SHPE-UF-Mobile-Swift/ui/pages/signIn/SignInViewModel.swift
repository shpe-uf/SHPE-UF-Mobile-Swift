//
//  SignInViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation
import CoreData

final class SignInViewModel: ObservableObject {
    @Published var usernameInput:String = ""
    @Published var passwordInput:String = ""
    @Published var userInCore:Bool = false
    
    func signIn() -> Bool
    {
        // Check that username and password map to a value in Mongo
        
            // Retrieve user data
            
                // Check that user is confirmed (Has responded to confirmation email)
        
                    // Create new user object
                    
                    // Clear core memory
        
                    // Add new user object to core
        
                    // return true
        
        return false
    }
    
    func createSHPEito()
    {
        
    }
    
    // MARK: DEV Functions
    
    func addUserItemToCore(viewContext:NSManagedObjectContext)
    {
        let user = User(context: viewContext)
        user.firstName = "Daniel"
        user.lastName = "Parra"
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
    
    func deleteUserItemToCore(viewContext:NSManagedObjectContext, user:User)
    {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
}
