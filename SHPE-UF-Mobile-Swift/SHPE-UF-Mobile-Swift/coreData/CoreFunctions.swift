//
//  CoreFunctions.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/28/24.
//

import Foundation
import CoreData
import SwiftUI

class CoreFunctions
{
    func editUserInCore(users:FetchedResults<User>, viewContext:NSManagedObjectContext, shpeito:SHPEito)
    {
        print(users.count)
        if let user = users.first
        {
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
    }
    
    func saveRedeemedEvents(events:FetchedResults<CoreUserEvent>, viewContext:NSManagedObjectContext, userEvents:[UserEvent])
    {
        for event in userEvents {
            let coreEvent = CoreUserEvent(context: viewContext)
            coreEvent.identifier = event.id
            coreEvent.points = Int16(event.points)
            coreEvent.name = event.name
            coreEvent.category = event.category
            coreEvent.createdAt = event.date
        }
        
        do { try viewContext.save() } catch {print("Could not save \(userEvents.count) User Even to Core")}
    }
}
