//
//  CheckCoreViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/10/24.
//

import Foundation
import CoreData
import SwiftUI

final class CheckCoreViewModel: ObservableObject {
    // Initialize SignInViewModel
    init() {}
    
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
               let links = foundUser.links as? [String]
            {
                let confirmed = foundUser.confirmed
                let fallPoints = Int(foundUser.fallPoints)
                let summerPoints = Int(foundUser.summerPoints)
                let springPoints = Int(foundUser.springPoints)
                let points = Int(foundUser.points)
                let fallPercentile = Int(foundUser.fallPercentile)
                let springPercentile = Int(foundUser.springPoints)
                let summerPercentile = Int(foundUser.springPercentile)
                let photo = foundUser.photo?.base64EncodedString() ?? ""

                print("Dark Mode: \(foundUser.darkMode)")
                AppViewModel.appVM.darkMode = foundUser.darkMode
                
                AppViewModel.appVM.shpeito = SHPEito(username: username, password: "* * * * *", remember: "", base64StringPhoto: photo, firstName: firstName, lastName: lastName, year: year, major: major, id: id, token: token, confirmed: confirmed, updatedAt: updatedAt, createdAt: createdAt, email: email, gender: gender, ethnicity: ethnicity, originCountry: originCountry, graduationYear: graduationYear, classes: classes, internships: internships, links: links, fallPoints: fallPoints, summerPoints: summerPoints, springPoints: springPoints, points: points, fallPercentile: fallPercentile, springPercentile: springPercentile, summerPercentile: summerPercentile)
                
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
    
    func deleteUserItemToCore(viewContext:NSManagedObjectContext, user:User)
    {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
}

