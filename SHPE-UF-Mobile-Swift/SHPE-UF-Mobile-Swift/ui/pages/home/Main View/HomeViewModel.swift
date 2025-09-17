//
//  HomeViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation
import CoreData
import SwiftUI

enum EventLoadMode {
    case dummyOnly
    case fetchedOnly
    case combined
}


/// Manages event data for the home screen, handling fetching, processing, and displaying calendar events.
///
/// This ViewModel:
/// 1. Fetches events from network and Core Data
/// 2. Processes events (sorting, categorizing, expanding multi-day events)
/// 3. Provides filtered upcoming events
/// 4. Supports debug/test modes with dummy data
///
/// ## Key Responsibilities
/// - Network data fetching through `RequestHandler`
/// - Event data processing and transformation
/// - State management through `@Published` properties
/// - Error handling and fallback to Core Data
///
/// ## Example Usage
/// ```swift
/// @StateObject var viewModel = HomeViewModel(coreEvents: fetchedEvents, viewContext: container.viewContext)
/// ```
final class HomeViewModel: ObservableObject {
    private var requestHandler = RequestHandler()
    private let loadMode: EventLoadMode // Type of use case
    
    @Published var events: [Event] = []
    
    //This is for testing events when there are no events present
    //Keep this commented if testing
    init(coreEvents : FetchedResults<CalendarEvent>, viewContext: NSManagedObjectContext, loadMode: EventLoadMode = .fetchedOnly) {
        
        self.loadMode = loadMode

        switch loadMode {
        case .dummyOnly:
            self.events = createDummyEvents()
            updateEventTypes()
            expandMultiDayEvents()
            saveEventsToCoreData(self.events, viewContext: viewContext)
        case .fetchedOnly, .combined:
            fetchEvents(coreEvents: coreEvents, viewContext: viewContext)
        }

    }
    

    
    /// Fetches and processes calendar events from both network and Core Data.
    ///
    /// This function:
    /// 1. Gets events starting from one month ago through the RequestHandler
    /// 2. Sorts events chronologically by start time
    /// 3. Updates event types and expands multi-day events
    /// 4. Falls back to Core Data if network request fails
    ///
    /// - Parameters:
    ///   - coreEvents: Fetched Core Data results to use as fallback
    ///   - viewContext: Managed object context for Core Data operations
    ///
    /// ## Data Flow
    /// 1. Sets minimum date range (1 month ago)
    /// 2. Attempts network fetch
    /// 3. On success:
    ///    - Sorts, categorizes, and expands events
    ///    - Updates local events array
    /// 4. On failure:
    ///    - Falls back to Core Data events
    ///    - Logs error message
    ///
    /// ## Important Notes
    /// - Always executes UI updates on main thread
    /// - Maintains chronological order of events
    /// - Preserves original functionality while being more robust
    func fetchEvents(coreEvents: FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext){
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
                guard let self = self else { return }
                
                var finalEvents: [Event] = []
                if self.loadMode == .dummyOnly || self.loadMode == .combined {
                    finalEvents += self.createDummyEvents()
                }
                if success {
                    // Sort the events by their start dates
                    
                    var sortedEvents = events.sorted(by: { $0.start.dateTime < $1.start.dateTime })
                    finalEvents += sortedEvents
                    // Update the events property with the sorted events
                    self.events = finalEvents.sorted { $0.start.dateTime < $1.start.dateTime }
                    
                    self.updateEventTypes()
                    self.expandMultiDayEvents()
                    
                    sortedEvents = self.events.sorted(by: { $0.start.dateTime < $1.start.dateTime })
                    self.events = sortedEvents
                    
                    /// NEW to save events to core Data
                    // Save to Core Data ?
                    self.saveEventsToCoreData(sortedEvents, viewContext: viewContext)
                    
                    
                } else {
                    // Handle error condition
                    self.events = CoreFunctions().mapCoreEventToEvent(events: coreEvents, viewContext: viewContext)
                    print("Error fetching events: \(error)")
                }
            }
        }
    
    }
    
    /// Retrieves all events that haven't ended yet.
    ///
    /// This function:
    /// 1. Filters events where the end time is in the future
    /// 2. Returns events in their original order
    /// 3. Uses the current system date/time for comparison
    ///
    /// - Returns: An array of upcoming `Event` objects
    ///
    /// ## Important Notes
    /// - Includes events that are currently ongoing
    /// - Comparison is timezone-aware (uses each event's timezone)
    /// - Returns empty array if no upcoming events exist
    ///
    /// ## Example Usage
    /// ```swift
    /// let upcoming = getUpcomingEvents()
    /// calendarView.display(upcoming)
    /// ```
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
    
    /// Categorizes events based on keywords found in their summaries.
    ///
    /// This function:
    /// 1. Scans event summaries for specific keywords
    /// 2. Assigns event types based on matched keywords
    /// 3. Provides a default categorization for unmatched events
    ///
    /// ## Event Type Classification Rules
    /// - "GBM" → General Body Meeting
    /// - "Bootcamp", "Workshop", "Tank", "work", "Symposium" → Workshop
    /// - "Social", "Fundraiser" → Social
    /// - "volunteering" → Volunteering
    /// - "Info" → Information Session
    /// - (default) → Social
    ///
    /// ## Important Notes
    /// - Matching is case-sensitive for "GBM" and case-insensitive for other keywords
    /// - Original event objects are modified in-place
    /// - Consider adding this logic to event initialization instead
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
    /// Expands multi-day events into multiple single-day events for display purposes.
    ///
    /// This function:
    /// 1. Identifies events spanning multiple days
    /// 2. Creates duplicate events for each day in the range
    /// 3. Preserves all original event metadata
    /// 4. Maintains single-day events unchanged
    ///
    /// ## Example
    /// A 3-day conference (Jan 1-3) becomes three separate events:
    /// - Jan 1 (original start to end of day)
    /// - Jan 2 (all day)
    /// - Jan 3 (start of day to original end)
    ///
    /// ## Important Notes
    /// - Original time components are preserved for first/last days
    /// - Timezone handling respects the original event's timezone
    /// - Does not modify the calendar - only creates display variants
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
                   end: EventDateTime(dateTime: formatter.date(from: "2025-08-016T23:00:00Z")!, timeZone: "UTC"),
                   etag: "123",
                   eventType: "GBM",
                   htmlLink: "http://example.com",
                   iCalUID: "event1",
                   identifier: "1",
                   kind: "calendar#event",
                   organizer: Organizer(email: "organizer@example.com", selfValue:0),
                   sequence: 0,
                   start: EventDateTime(dateTime: formatter.date(from: "2025-08-16T02:00:00Z")!, timeZone: "UTC"),
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
