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
        let appVM = AppViewModel.appVM
        if !user.isEmpty
        {
            let foundUser = user[0]
            if let username = foundUser.username,
               let photoURL = foundUser.photo,
               let firstName = foundUser.firstName,
               let lastName = foundUser.lastName,
               let year = foundUser.year,
               let major = foundUser.major,
               let id = foundUser.id,
               let token = foundUser.token,
               let updatedAt = foundUser.updatedAt,
               let createdAt = foundUser.createdAt,
               let email = foundUser.email
            {
                let confirmed = foundUser.confirmed
                let fallPoints = Int(foundUser.fallPoints)
                let summerPoints = Int(foundUser.summerPoints)
                let springPoints = Int(foundUser.springPoints)
                let points = Int(foundUser.points)
                let fallPercentile = Int(foundUser.fallPercentile)
                let springPercentile = Int(foundUser.springPoints)
                let summerPercentile = Int(foundUser.springPercentile)
                
                appVM.shpeito = SHPEito(username: username, password: "* * * * *", remember: "", firstName: firstName, lastName: lastName, year: year, major: major, id: id, token: token, confirmed: confirmed, updatedAt: updatedAt, createdAt: createdAt, email: email, fallPoints: fallPoints, summerPoints: summerPoints, springPoints: springPoints, points: points, fallPercentile: fallPercentile, springPercentile: springPercentile, summerPercentile: summerPercentile)
                
                appVM.setPageIndex(index: 2)
            }
            else
            {
                appVM.setPageIndex(index: 0)
            }
        }
        else
        {
            appVM.setPageIndex(index: 0)
        }
    }
    
    func deleteUserItemToCore(viewContext:NSManagedObjectContext, user:User)
    {
        viewContext.delete(user)
        do { try viewContext.save() } catch { print("Could not save to Core") }
    }
}

