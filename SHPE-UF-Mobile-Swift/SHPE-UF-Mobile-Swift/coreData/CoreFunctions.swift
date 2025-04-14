//
//  CoreFunctions.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/28/24.
//

import Foundation
import CoreData
import SwiftUI
/// A utility class for common Core Data operations.
///
/// `CoreFunctions` provides methods for creating, updating, and deleting Core Data entities,
/// as well as converting between Core Data entities and model objects.
///
/// # Example
/// ```swift
/// let coreFunctions = CoreFunctions()
/// coreFunctions.editUserInCore(users: fetchedUsers, viewContext: context, shpeito: currentUser)
/// ```
class CoreFunctions
{
    /// Updates a User entity in Core Data with data from a SHPEito model.
    ///
    /// - Parameters:
    ///   - users: The fetched results containing the user to update
    ///   - viewContext: The managed object context
    ///   - shpeito: The SHPEito model containing the updated user data
    func editUserInCore(users:FetchedResults<User>, viewContext:NSManagedObjectContext, shpeito:SHPEito)
    {
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
    
    /// Updates notification settings for a user in Core Data.
    ///
    /// - Parameters:
    ///   - users: The fetched results containing the user to update
    ///   - viewContext: The managed object context
    ///   - shpeito: The SHPEito model for the user
    func editUserNotificationSettings(users:FetchedResults<User>, viewContext:NSManagedObjectContext, shpeito:SHPEito)
    {
        if let user = users.first
        {
            user.gbmNotif = NotificationViewModel.instance.isGBMSelected
            user.infoNotif = NotificationViewModel.instance.isInfoSelected
            user.workNotif = NotificationViewModel.instance.isWorkShopSelected
            user.volNotif = NotificationViewModel.instance.isVolunteeringSelected
            user.socialNotif = NotificationViewModel.instance.isSocialSelected
            
            do { try viewContext.save() } catch { print("Could not save user notification settings to Core") }
        }
    }
    /// Saves redeemed events to Core Data.
    ///
    /// This method creates `CoreUserEvent` entities for each event in the provided array.
    ///
    /// - Parameters:
    ///   - events: The fetched results of existing CoreUserEvent entities
    ///   - viewContext: The managed object context
    ///   - userEvents: An array of UserEvent models to save
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
    /// Saves calendar events to Core Data.
    ///
    /// This method creates `CalendarEvent` entities for each event in the provided array.
    ///
    /// - Parameters:
    ///   - events: The fetched results of existing CalendarEvent entities
    ///   - viewContext: The managed object context
    ///   - calendarEvents: An array of Event models to save
    func saveCalendarEvent(events:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext, calendarEvents:[Event])
    {
        for event in calendarEvents {
            let coreCalEvent = CalendarEvent(context: viewContext)
            coreCalEvent.identifier = event.identifier
            coreCalEvent.eventType = event.eventType
            coreCalEvent.location = event.location ?? ""
            coreCalEvent.summary = event.summary
            coreCalEvent.start = event.start.dateTime
            coreCalEvent.end = event.end.dateTime
        }
        
        do { try viewContext.save() } catch {print("Could not save \(calendarEvents.count) User Even to Core")}
    }
    /// Removes a calendar event from Core Data.
    ///
    /// - Parameters:
    ///   - viewContext: The managed object context
    ///   - coreEvent: The CalendarEvent entity to remove
    func removeCalendarEventFromCore(viewContext:NSManagedObjectContext, coreEvent:CalendarEvent)
    {
        viewContext.delete(coreEvent)
        do { try viewContext.save() } catch { print("Could not update calendar events in Core") }
    }
    /// Updates calendar events in Core Data, removing past events.
    ///
    /// This method compares event start dates with the current date and removes
    /// events that have already occurred.
    ///
    /// - Parameters:
    ///   - events: The fetched results of existing CalendarEvent entities
    ///   - viewContext: The managed object context
    func updateCalendarEvent(events:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext)
    {
        var coreEventsToRemove:[CalendarEvent] = []
        for event in events
        {
            if let startDate = event.start
            {
                if startDate < Date()
                {
                    coreEventsToRemove.append(event)
                }
            }
        }
        for eventToRemove in coreEventsToRemove
        {
            viewContext.delete(eventToRemove)
        }
        do { try viewContext.save() } catch { print("Could not update calendar events in Core") }
    }
    /// Converts Core Data calendar events to Event model objects.
    ///
    /// - Parameters:
    ///   - events: The fetched results of CalendarEvent entities
    ///   - viewContext: The managed object context
    /// - Returns: An array of Event model objects
    func mapCoreEventToEvent(events:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext)->[Event]
    {
        var eventObjectArray:[Event] = []
        for event in events
        {
            if let start = event.start,
               let end = event.end,
               let summary = event.summary,
               let identifier = event.identifier,
               let eventType = event.eventType
            {
                eventObjectArray.append(Event(created: Date(), creator: Creator(email: "", selfValue: 0), end: EventDateTime(dateTime: end, timeZone: "EST"), etag: "", eventType: eventType, htmlLink: "", iCalUID: "", identifier: identifier, kind: "", organizer: Organizer(email: "", selfValue: 0), sequence: 0, start: EventDateTime(dateTime: start, timeZone: "EST"), status: "", summary: summary, updated: Date(), location: event.location, description: event.desc))
            }
            
        }
        return eventObjectArray
    }
    /// Clears all entities from Core Data.
    ///
    /// This method removes all CalendarEvent, User, and CoreUserEvent entities
    /// from the persistent store.
    ///
    /// - Parameters:
    ///   - events: The fetched results of CalendarEvent entities
    ///   - users: The fetched results of User entities
    ///   - userEvents: The fetched results of CoreUserEvent entities
    ///   - viewContext: The managed object context
    func clearCore(events:FetchedResults<CalendarEvent>, users:FetchedResults<User>, userEvents:FetchedResults<CoreUserEvent>, viewContext:NSManagedObjectContext)
    {
        for event in events
        {
            viewContext.delete(event)
        }
        
        for user in users
        {
            viewContext.delete(user)
        }
        
        for event in userEvents
        {
            viewContext.delete(event)
        }
        
        do { try viewContext.save() } catch { print("Could not clear core") }
    }
}
