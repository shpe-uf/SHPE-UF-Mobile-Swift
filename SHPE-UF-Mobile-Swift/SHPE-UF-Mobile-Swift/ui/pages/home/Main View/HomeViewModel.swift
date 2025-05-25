//
//  HomeViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation
import CoreData
import SwiftUI

final class HomeViewModel: ObservableObject {
    private var requestHandler = RequestHandler()
    
    @Published var events: [Event] = []
    
    //This is for testing events when there are no events present
    //Keep this commented if testing
    init(coreEvents : FetchedResults<CalendarEvent>, viewContext: NSManagedObjectContext, useDummyEvents: Bool = false) {
        if useDummyEvents {
            self.events = createDummyEvents()
            updateEventTypes()
            expandMultiDayEvents()
            saveEventsToCoreData(self.events, viewContext: viewContext)
        }
        else {
            fetchEvents(coreEvents: coreEvents, viewContext: viewContext)
        }

    }
    

    
    func fetchEvents(coreEvents: FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext, useDummyEvents: Bool = false){
        // Set the minimum date for events to be fetched (e.g., today's date)
        
        func dateOneMonthAgo() -> Date? {
            // Get the current calendar and today's date
            let calendar = Calendar.current
            let currentDate = Date()
            
            // Calculate the date components for one month ago
            var dateComponents = DateComponents()
            dateComponents.month = -1
            
            // Get the date one month ago
            return calendar.date(byAdding: dateComponents, to: currentDate)
        }
        
        let minDate = dateOneMonthAgo()!
        
        
        // Call the fetchEvents method from the RequestHandler
        requestHandler.fetchEvents(minDate: minDate) { [weak self] (events, success, error) in
            DispatchQueue.main.async {
                if success {
                    // Sort the events by their start dates
                    var sortedEvents = events.sorted(by: { $0.start.dateTime < $1.start.dateTime })
                    // Update the events property with the sorted events
                    self?.events = sortedEvents
                    self?.updateEventTypes()
                    self?.expandMultiDayEvents()
                    
                    sortedEvents = self?.events.sorted(by: { $0.start.dateTime < $1.start.dateTime }) ?? []
                    self?.events = sortedEvents
                    
                    /// NEW to save events to core Data
                    // Save to Core Data ?
                    self?.saveEventsToCoreData(sortedEvents, viewContext: viewContext)
                    
                } else {
                    // Handle error condition
                    self?.events = CoreFunctions().mapCoreEventToEvent(events: coreEvents, viewContext: viewContext)
                    print("Error fetching events: \(error)")
                }
            }
        }
    
    }
    
    func getUpcomingEvents()->[Event]
    {
        var upcomingEvents:[Event] = []
        for event in events
        {
            if event.end.dateTime > Date()
            {
                upcomingEvents.append(event)
            }
        }
        return upcomingEvents
    }
    
    private func updateEventTypes() {
            for index in 0..<events.count {
                let event = events[index]
                
                // Changes event types based on keywords in title of event
                
                if event.summary.contains("GBM") {
                    events[index].eventType = "GBM"
                } else if event.summary.contains("Bootcamp") || event.summary.contains("Workshop") || event.summary.contains("Tank") || event.summary.contains("work") || event.summary.contains("Symposium") {
                    events[index].eventType = "Workshop"
                } else if event.summary.contains("Social") || event.summary.contains("Fundraiser") {
                    events[index].eventType = "Social"
                } else if event.summary.contains("volunteering") {
                    events[index].eventType = "Volunteering"
                }else if event.summary.contains("Info") {
                    events[index].eventType = "Info"
                }else{
                    events[index].eventType = "Social"
                }
                
            }
    }
    private func expandMultiDayEvents() {
        var expandedEvents: [Event] = []
        
        for event in events {
            let numberOfDays = Calendar.current.dateComponents([.day], from: event.start.dateTime, to: event.end.dateTime).day ?? 1
            
            if numberOfDays > 1 {
                for dayOffset in 0..<numberOfDays {
                    if let newStartDateTime = Calendar.current.date(byAdding: .day, value: dayOffset, to: event.start.dateTime),
                       let newEndDateTime = Calendar.current.date(byAdding: .day, value: dayOffset, to: event.end.dateTime) {
                       
                        let newEvent = Event(created: event.created,
                                             creator: event.creator,
                                             end: EventDateTime(dateTime: newEndDateTime, timeZone: event.end.timeZone),
                                             etag: event.etag,
                                             eventType: event.eventType,
                                             htmlLink: event.htmlLink,
                                             iCalUID: event.iCalUID,
                                             identifier: event.identifier,
                                             kind: event.kind,
                                             organizer: event.organizer,
                                             sequence: event.sequence,
                                             start: EventDateTime(dateTime: newStartDateTime, timeZone: event.start.timeZone),
                                             status: event.status,
                                             summary: event.summary,
                                             updated: event.updated,
                                             location: event.location,
                                             description: event.description
                        )
         
                        expandedEvents.append(newEvent)
                    }
                }
            } else {
             
                expandedEvents.append(event)
            }
        }
        
        // Update the events property with the expanded events
        events = expandedEvents
    }
    
    /// Saving Events to CoreData?
    func saveEventsToCoreData(_ events: [Event], viewContext: NSManagedObjectContext) {
        for event in events {
            let calendarEvent = CalendarEvent(context: viewContext)
            calendarEvent.identifier = event.identifier
            calendarEvent.summary = event.summary
            calendarEvent.start = event.start.dateTime
            calendarEvent.end = event.end.dateTime
            calendarEvent.location = event.location
            calendarEvent.eventType = event.eventType
            calendarEvent.desc = event.description
        }
        
        DispatchQueue.main.async {
            do {
                try viewContext.save()
                print("✅ Saved \(events.count) events to Core Data")
            } catch {
                print("Failed to save: \(error)")
            }
        }
    }
    
    
    /// For testing create dummy events
   func createDummyEvents() -> [Event] {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
           
           return [
               Event(
                   created: Date(),
                   creator: Creator(email: "test1@example.com", selfValue: 0),
                   end: EventDateTime(dateTime: formatter.date(from: "2025-05-016T23:00:00Z")!, timeZone: "UTC"),
                   etag: "123",
                   eventType: "GBM",
                   htmlLink: "http://example.com",
                   iCalUID: "event1",
                   identifier: "1",
                   kind: "calendar#event",
                   organizer: Organizer(email: "organizer@example.com", selfValue:0),
                   sequence: 0,
                   start: EventDateTime(dateTime: formatter.date(from: "2025-05-16T02:00:00Z")!, timeZone: "UTC"),
                   status: "confirmed",
                   summary: "GBM #1",
                   updated: Date(),
                   location: "655 Reitz Union Drive, Campus, Gainesville, FL 32611",
                   description: "End of year GBM"
               ),
               Event(
                   created: Date(),
                   creator: Creator(email: "test2@example.com", selfValue: 0),
                   end: EventDateTime(dateTime: formatter.date(from: "2025-12-31T23:59:00Z")!, timeZone: "UTC"),
                   etag: "456",
                   eventType: "Social",
                   htmlLink: "http://example.com",
                   iCalUID: "event2",
                   identifier: "2",
                   kind: "calendar#event",
                   organizer: Organizer(email: "organizer@example.com", selfValue: 0),
                   sequence: 0,
                   start: EventDateTime(dateTime: formatter.date(from: "2025-12-31T20:00:00Z")!, timeZone: "UTC"),
                   status: "confirmed",
                   summary: "SHPE 2025 Convention",
                   updated: Date(),
                   location:"790 W Katella Ave, Anaheim",
                   description: "Ring in the New Year with us!"
               ),
               Event(
                   created: Date(),
                   creator: Creator(email: "test3@example.com", selfValue: 0),
                   end: EventDateTime(dateTime: formatter.date(from: "2025-10-10T10:00:00Z")!, timeZone: "UTC"),
                   etag: "789",
                   eventType: "Workshop",
                   htmlLink: "http://example.com",
                   iCalUID: "event3",
                   identifier: "3",
                   kind: "calendar#event",
                   organizer: Organizer(email: "organizer@example.com", selfValue: 0),
                   sequence: 0,
                   start: EventDateTime(dateTime: formatter.date(from: "2025-10-10T08:00:00Z")!, timeZone: "UTC"),
                   status: "confirmed",
                   summary: "New Year's Resolution Workshop",
                   updated: Date(),
                   location: "1545 W University Ave, Gainesville, FL 32603",
                   description: "Plan your resolutions and achieve your goals!"
               )
           ]
       
       }
}
