import Foundation
import SwiftUI
import CoreData

final class SignInViewModel: ObservableObject
{
    private var requestHandler = RequestHandler()
    
    @Published var shpeito: SHPEito
    @Published var viewPassword: Bool = false
    @Published var error: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    @Published var toastDuration = 3.0
    @Published var isCommunicating: Bool = false
    
    // In View variables
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
    @Published var permission: String
    
    init(shpeito: SHPEito) {
        self.shpeito = shpeito
        self.username = shpeito.username
        self.password = shpeito.password
        self.remember = shpeito.remember
        self.firstName = shpeito.firstName
        self.lastName = shpeito.lastName
        self.year = shpeito.year
        self.major = shpeito.major
        self.id = shpeito.id
        self.token = shpeito.token
        self.confirmed = shpeito.confirmed
        self.updatedAt = shpeito.updatedAt
        self.createdAt = shpeito.createdAt
        self.email = shpeito.email
        self.fallPoints = shpeito.fallPoints
        self.springPoints = shpeito.springPoints
        self.summerPoints = shpeito.summerPoints
        self.permission = shpeito.permission
    }
    
    func signIn(username: String, password: String, viewContext: NSManagedObjectContext) {
        self.shpeito.username = username
        self.shpeito.password = password
        self.isCommunicating = true

        requestHandler.signIn(username: username, password: password) { data in
            self.isCommunicating = false

            if let error = data["error"] as? String {
                return
            } else {
                self.isCommunicating = true

                // Extract permission from API response
                let permissionValue = data["permission"] as? String ?? ""

                // Update user data
                self.shpeito = SHPEito(
                    username: data["username"] as? String ?? "",
                    password: password,
                    remember: "True",
                    base64StringPhoto: (data["photo"] as? String)?.replacingOccurrences(of: "data:image/jpeg;base64,", with: "") ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    year: data["year"] as? String ?? "",
                    major: data["major"] as? String ?? "",
                    id: data["id"] as? String ?? "",
                    token: data["token"] as? String ?? "",
                    confirmed: data["confirmed"] as? Bool ?? false,
                    updatedAt: data["updatedAt"] as? String ?? "",
                    createdAt: data["createdAt"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    gender: data["gender"] as? String ?? "",
                    ethnicity: data["ethnicity"] as? String ?? "",
                    originCountry: data["originCountry"] as? String ?? "",
                    graduationYear: data["graduationYear"] as? String ?? "",
                    classes: data["classes"] as? [String] ?? [],
                    internships: data["internships"] as? [String] ?? [],
                    links: data["links"] as? [String] ?? [],
                    permission: permissionValue, // ✅ Store permission
                    fallPoints: 0,
                    summerPoints: 0,
                    springPoints: 0,
                    points: 0,
                    fallPercentile: 0,
                    springPercentile: 0,
                    summerPercentile: 0
                )

                // Update the local property in the view model
                self.permission = self.shpeito.permission

                // Persist to CoreData
                self.updatePermissionInCoreData(permissionValue, viewContext: viewContext)

                // Update AppViewModel state
                AppViewModel.appVM.shpeito = self.shpeito
                AppViewModel.appVM.setPageIndex(index: 2)
            }
        }
    }

    private func addUserItemToCore(viewContext: NSManagedObjectContext) {
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
        
        do {
            try viewContext.save()
        } catch {
            print("Could not save user to Core")
        }
    }
    
    func deleteUserItemToCore(viewContext: NSManagedObjectContext, user: User) {
        viewContext.delete(user)
        do {
            try viewContext.save()
        } catch {
            print("Could not delete user from Core")
        }
    }
    
    func refreshUserPermission(viewContext: NSManagedObjectContext)
    {
        guard !self.id.isEmpty else { return } // Ensure the user is logged in
        
        requestHandler.fetchUserPermission(userId: self.id) { newPermission in
            DispatchQueue.main.async {
                if let newPermission = newPermission, self.permission != newPermission {
                    print("🔄 Updating permission: \(self.permission) → \(newPermission)")

                    // Update SignInViewModel
                    self.permission = newPermission
                    
                    // Update SHPEito model
                    self.shpeito.permission = newPermission

                    // Update CoreData
                    self.updatePermissionInCoreData(newPermission, viewContext: viewContext)
                }
            }
        }
    }

    private func updatePermissionInCoreData(_ newPermission: String, viewContext: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                user.permission = newPermission
                try viewContext.save()
                print("✅ Updated permission in CoreData: \(newPermission)")
            }
        } catch {
            print("❌ Failed to update permission in CoreData")
        }
    }


    
    
}
