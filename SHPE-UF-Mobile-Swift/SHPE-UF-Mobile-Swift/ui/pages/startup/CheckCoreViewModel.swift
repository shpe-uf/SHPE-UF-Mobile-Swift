//
//  CheckCoreViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/10/24.
//

import Foundation
import CoreData
import SwiftUI
/// A view model responsible for handling authentication verification during app startup.
///
/// `CheckCoreViewModel` plays a critical role in the app's initialization process by:
/// - Verifying if a user is already authenticated in Core Data
/// - Extracting user information to create a user model
/// - Setting up app-wide preferences and notification settings based on stored data
/// - Directing the navigation flow to either the main app or login screen
///
/// This view model acts as a bridge between the persistent storage layer and
/// the app's main view models, ensuring proper initialization of user state.
///
/// ## Authentication Flow
///
/// During app startup, this view model checks Core Data for existing user information:
/// - If valid user data exists, it recreates the user model and navigates to the main app
/// - If user data is incomplete or doesn't exist, it directs to the login screen
///
/// ## Integration
///
/// `CheckCoreViewModel` is typically used in conjunction with the ``CheckCore`` view
/// which serves as the app's splash screen.
///
/// ## Example
///
/// ```swift
/// let viewModel = CheckCoreViewModel()
/// viewModel.checkUserInCore(user: userFetchResults)
/// ```
final class CheckCoreViewModel: ObservableObject {
    // Initialize SignInViewModel
    init() {}
    /// Verifies if a valid user exists in Core Data and handles initialization accordingly.
    ///
    /// This method examines the provided user fetch results to determine if a valid,
    /// authenticated user exists in the app's local storage. Based on the results:
    ///
    /// - If a complete user record exists, it:
    ///   1. Extracts all user information
    ///   2. Recreates the user model (`SHPEito`)
    ///   3. Initializes app settings (dark mode)
    ///   4. Sets up notification preferences
    ///   5. Navigates to the main app interface
    ///
    /// - If no user exists or user data is incomplete, it navigates to the login screen
    ///
    /// - Parameter user: The Core Data fetch results containing user records
    func checkUserInCore(user: FetchedResults<User>)
    {
        if !user.isEmpty
        {
            let foundUser = user[0]

            if let username = foundUser.username,
               let firstName = foundUser.firstName,
               let lastName = foundUser.lastName,
               let year = foundUser.year,
               let major = foundUser.major,
               let id = foundUser.id,
               let token = foundUser.token,
               let updatedAt = foundUser.updatedAt,
               let createdAt = foundUser.createdAt,
               let email = foundUser.email,
               let gender = foundUser.gender,
               let ethnicity = foundUser.ethnicity,
               let originCountry = foundUser.country,
               let graduationYear = foundUser.graduating,
               let classes = foundUser.classes as? [String],
               let internships = foundUser.internships as? [String],
               let links = foundUser.links as? [String],
               let permission = foundUser.permission
                
            {
                let confirmed = foundUser.confirmed
                let fallPoints = Int(foundUser.fallPoints)
                let summerPoints = Int(foundUser.summerPoints)
                let springPoints = Int(foundUser.springPoints)
                let points = Int(foundUser.points)
                let fallPercentile = Int(foundUser.fallPercentile)
                let springPercentile = Int(foundUser.springPercentile)
                let summerPercentile = Int(foundUser.summerPercentile)
                let photo = foundUser.photo?.base64EncodedString() ?? ""

                // Set dark mode based on CoreData user preference
                AppViewModel.appVM.darkMode = foundUser.darkMode
                
                // Set notification preferences
                NotificationViewModel.instance.isGBMSelected = foundUser.gbmNotif
                NotificationViewModel.instance.isInfoSelected = foundUser.infoNotif
                NotificationViewModel.instance.isWorkShopSelected = foundUser.workNotif
                NotificationViewModel.instance.isVolunteeringSelected = foundUser.volNotif
                NotificationViewModel.instance.isSocialSelected = foundUser.socialNotif
                                
                // Assign to AppViewModel
                AppViewModel.appVM.shpeito = SHPEito(
                    username: username,
                    password: "* * * * *",
                    remember: "",
                    base64StringPhoto: photo,
                    firstName: firstName,
                    lastName: lastName,
                    year: year,
                    major: major,
                    id: id,
                    token: token,
                    confirmed: confirmed,
                    updatedAt: updatedAt,
                    createdAt: createdAt,
                    email: email,
                    gender: gender,
                    ethnicity: ethnicity,
                    originCountry: originCountry,
                    graduationYear: graduationYear,
                    classes: classes,
                    internships: internships,
                    links: links,
                    permission: permission,
                    fallPoints: fallPoints,
                    summerPoints: summerPoints,
                    springPoints: springPoints,
                    points: points,
                    fallPercentile: fallPercentile,
                    springPercentile: springPercentile,
                    summerPercentile: summerPercentile
                )
                
                AppViewModel.appVM.setPageIndex(index: 2)
            }
            else
            {
                print("User exists but could not access all data necessary")
                AppViewModel.appVM.setPageIndex(index: 3)
            }
        }
        else
        {
            print("No Users in Core")
            AppViewModel.appVM.setPageIndex(index: 3)
        }
    }
    /// Deletes a user record from Core Data.
    ///
    /// This utility method provides a way to remove a user from the local database,
    /// typically used during logout or account deletion processes.
    ///
    /// - Parameters:
    ///   - viewContext: The Core Data managed object context
    ///   - user: The user entity to delete
    func deleteUserItemToCore(viewContext:NSManagedObjectContext, user:User)
    {
        viewContext.delete(user)
        do
        {
            try viewContext.save()
        }
        catch
        {
            print("Could not save to Core")
        }
    }
}
