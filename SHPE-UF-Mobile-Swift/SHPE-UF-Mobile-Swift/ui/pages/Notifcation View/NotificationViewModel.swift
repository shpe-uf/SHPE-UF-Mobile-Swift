//
//  NotificationViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 2/17/24.
//

import SwiftUI
import UserNotifications
import CoreData

/// Manages all notification-related functionality for calendar events.
///
/// This ViewModel:
/// 1. Handles notification permissions and authorization status
/// 2. Manages notification scheduling/removal for different event types
/// 3. Maintains synchronization between UI state, Core Data, and system notifications
/// 4. Provides debugging utilities for notification management
///
/// ## Key Features
/// - Singleton pattern ensures single source of truth
/// - Published properties for SwiftUI binding
/// - Supports five distinct event types with individual toggle states
/// - Automatic cleanup of expired notifications
///
/// ## Example Usage
/// ```swift
/// // Schedule notifications for an event
/// NotificationViewModel.instance.notifyForSingleEvent(
///     event: newEvent,
///     fetchedEvents: fetchedEvents,
///     viewContext: context
/// )
///
/// // Check notification permissions
/// NotificationViewModel.instance.checkForPermission { allowed in
///     if allowed { /* proceed */ }
/// }
/// ```
class NotificationViewModel : ObservableObject {
    
    static let instance  = NotificationViewModel()
    
    @Published var isGBMSelected = false
    @Published var isInfoSelected = false
    @Published var isWorkShopSelected = false
    @Published var isVolunteeringSelected = false
    @Published var isSocialSelected = false
    
    @Published var pendingNotifications:[Event] = []
    
    @Published var notificationsAllowed = false
    
    private init () {}
    
    /// Updates the notification toggle state for a specific event type.
    ///
    /// This function:
    /// 1. Toggles or sets the notification preference for the specified event type
    /// 2. Handles five different event types (GBM, Info, Workshop, Volunteering, Social)
    /// 3. Provides optional forced state setting via `setTo` parameter
    ///
    /// - Parameters:
    ///   - eventType: The type of event to modify (case-sensitive)
    ///   - setTo: Optional forced state (true/false). When nil, toggles current state.
    ///
    /// ## Important
    /// - Must be called from main thread (updates UI state)
    /// - Default case logs invalid types but doesn't crash
    /// - Uses forced unwrapping for `setTo` when provided (safe due to nil check)
    ///
    /// ## Example
    /// ```swift
    /// // Toggle current state
    /// buttonClicked(eventType: "GBM")
    ///
    /// // Force set state
    /// buttonClicked(eventType: "Workshop", setTo: true)
    /// ```
    private func buttonClicked(eventType:String, setTo:Bool? = nil)
    {
        switch eventType {
        case "GBM":
            isGBMSelected.toggle()
            isGBMSelected = setTo == nil ? isGBMSelected : setTo!
        case "Info":
            isInfoSelected.toggle()
            isInfoSelected = setTo == nil ? isInfoSelected : setTo!
        case "Workshop":
            isWorkShopSelected.toggle()
            isWorkShopSelected = setTo == nil ? isWorkShopSelected : setTo!
        case "Volunteering":
            isVolunteeringSelected.toggle()
            isVolunteeringSelected = setTo == nil ? isVolunteeringSelected : setTo!
        case "Social":
            isSocialSelected.toggle()
            isSocialSelected = setTo == nil ? isSocialSelected : setTo!
        default:
            print("Invalid Notificatiion Type")
        }
    }
    
    /// Checks and optionally requests notification permissions, returning the current authorization status.
    ///
    /// This function:
    /// 1. Checks the current notification permission status
    /// 2. Handles all possible authorization states (.authorized, .denied, .notDetermined)
    /// 3. Requests permission if status is .notDetermined
    /// 4. Updates `notificationsAllowed` property and executes completion handler
    ///
    /// - Parameter completion: Optional closure returning the authorization status (true if authorized)
    ///                       Defaults to empty closure if not needed.
    ///
    /// ## Important
    /// - Must be called from main thread (updates UI state)
    /// - Completion handler is always called on main thread
    /// - Requests both alert and sound permissions when needed
    ///
    /// ## Example
    /// ```swift
    /// // Basic usage
    /// checkForPermission()
    ///
    /// // Usage with completion handler
    /// checkForPermission { allowed in
    ///     print("Notifications allowed: \(allowed)")
    ///     if allowed {
    ///         scheduleInitialNotifications()
    ///     }
    /// }
    /// ```
    func checkForPermission(completion: @escaping (Bool)->Void = {_ in }) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    // Do something when notification permission is authorized
                    print("Notification permission is authorized")
                    self.notificationsAllowed = true
                    
                case .denied:
                    // Do something when notification permission is denied
                    print("Notification permission is denied")
                    self.notificationsAllowed = false
                    
                    
                case .notDetermined:
                    notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                        if didAllow {
                            // Do something when notification permission is granted
                            print("Notification permission is granted")
                            self.notificationsAllowed = true
                            
                        }
                        if let error = error {
                            print("ERROR: \(error)")
                            self.notificationsAllowed = false
                        }
                    }
                default:
                    self.notificationsAllowed = false
                    break
                }
                completion(self.notificationsAllowed)
            }
        }
    }
    
    
    /// Schedules a notification for a single event and updates Core Data storage.
    ///
    /// This function:
    /// 1. Calculates the appropriate notification time based on event duration
    /// 2. Updates the in-memory tracking of pending notifications
    /// 3. Schedules the system notification
    /// 4. Persists changes to Core Data
    ///
    /// - Parameters:
    ///   - event: The `Event` to schedule notification for
    ///   - fetchedEvents: Fetched results container for CalendarEvent entities
    ///   - viewContext: Managed object context for Core Data operations
    ///
    /// ## Notification Timing Logic
    /// - For timed events (start ≠ end): Notifies 30 minutes before start
    /// - For all-day events (start = end): Notifies 12 hours before start
    ///
    /// ## Important
    /// - Requires UserNotifications framework permission
    /// - Must be called on main queue (affects Core Data and UI)
    /// - Maintains both in-memory `pendingNotifications` and persistent storage
    ///
    /// ## Example
    /// ```swift
    /// notifyForSingleEvent(
    ///     event: importantMeeting,
    ///     fetchedEvents: fetchedResults,
    ///     viewContext: container.viewContext
    /// )
    /// ```
    func notifyForSingleEvent(event:Event, fetchedEvents:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext)
    {
        var notificationDate = event.start.dateTime
        if event.start.dateTime != event.end.dateTime {
            // Notify 30 minutes before the event start time
            notificationDate = Calendar.current.date(byAdding: .minute, value: -30, to: notificationDate)!
        } else {
            // If the event is all-day, notify 12 hours before the start time
            notificationDate = Calendar.current.date(byAdding: .hour, value: -12, to: notificationDate)!
        }
        updatePendingNotifications()
        pendingNotifications.append(event)
        dispatchNotification(event: event, date: notificationDate)
        CoreFunctions().updateCalendarEvent(events: fetchedEvents, viewContext: viewContext)
        CoreFunctions().saveCalendarEvent(events: fetchedEvents, viewContext: viewContext, calendarEvents: [event])
    }
    
    /// Removes all traces of a single event's notification from both Core Data and the notification system.
    ///
    /// This function performs three main actions:
    /// 1. Locates and removes the event from Core Data (if found)
    /// 2. Cancels any pending notification for the event
    /// 3. Updates the in-memory `pendingNotifications` collection
    ///
    /// - Parameters:
    ///   - event: The `Event` object to remove
    ///   - fetchedEvents: Fetched results container for CalendarEvent entities
    ///   - viewContext: Managed object context for Core Data operations
    ///
    /// ## Important
    /// - Must be called on the main queue (performs Core Data operations)
    /// - Performs a permanent deletion from Core Data
    /// - Notification identifier is constructed as "identifier:::eventType"
    ///
    /// ## Example
    /// ```swift
    /// removeNotificationForSingleEvent(
    ///     event: cancelledEvent,
    ///     fetchedEvents: fetchedResults,
    ///     viewContext: container.viewContext
    /// )
    /// ```
    func removeNotificationForSingleEvent(event:Event, fetchedEvents:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext)
    {
        let foundEventInCore:CalendarEvent? = {
            for e in fetchedEvents
            {
                if let id = e.identifier,
                   id == event.identifier
                {
                    return e
                }
            }
            return nil
        }()
        
        // Delete event from core
        if let foundEvent = foundEventInCore
        {
            viewContext.delete(foundEvent)
        }
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [event.identifier + ":::" + event.eventType])
        updatePendingNotifications()
        pendingNotifications.removeAll(where: { e in
            e.identifier == event.identifier
        })
    }
    
    /// Enables notifications for all events of a specific type and updates Core Data.
    ///
    /// This function:
    /// 1. Updates the UI state to reflect notifications are enabled
    /// 2. Calculates appropriate notification times based on event duration
    /// 3. Schedules notifications for each matching event
    /// 4. Updates in-memory tracking and Core Data storage
    ///
    /// - Parameters:
    ///   - events: Array of `Event` objects to process
    ///   - eventType: The type of events to enable notifications for (e.g., "meeting")
    ///   - fetchedEvents: Fetched results container for CalendarEvent entities
    ///   - viewContext: Managed object context for Core Data operations
    ///
    /// ## Notification Timing Logic
    /// - For timed events (start ≠ end): Notifies 15 minutes before start
    /// - For all-day events (start = end): Notifies 24 hours before start
    ///
    /// ## Important
    /// - Requires UserNotifications permission
    /// - Must be called on the main queue (affects Core Data and UI)
    /// - Maintains both in-memory `pendingNotifications` and persistent storage
    ///
    /// ## Example
    /// ```swift
    /// turnOnEventNotification(
    ///     events: upcomingEvents,
    ///     eventType: "reminder",
    ///     fetchedEvents: fetchedResults,
    ///     viewContext: container.viewContext
    /// )
    /// ```
    func turnOnEventNotification(events:[Event], eventType: String, fetchedEvents:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext) {
        buttonClicked(eventType: eventType, setTo: true)
        for event in events {
            if event.eventType == eventType {
                var notificationDate = event.start.dateTime
                let dateHelper = DateHelper()
                let startTimeString = dateHelper.getTime(for: event.start.dateTime)
                let endTimeString = dateHelper.getTime(for: event.end.dateTime)
                
                if startTimeString != endTimeString {
                    // Notify 15 minutes before the event start time
                    notificationDate = Calendar.current.date(byAdding: .minute, value: -15, to: event.start.dateTime)!
                } else {
                    // If the event is all-day, notify 24 hours before the start time
                    notificationDate = Calendar.current.date(byAdding: .hour, value: -24, to: event.start.dateTime)!
                }
                
                // Dispatch notification
                updatePendingNotifications()
                pendingNotifications.append(event)
                dispatchNotification(event: event, date: notificationDate)
                CoreFunctions().updateCalendarEvent(events: fetchedEvents, viewContext: viewContext)
                CoreFunctions().saveCalendarEvent(events: fetchedEvents, viewContext: viewContext, calendarEvents: [event])

            }
        }
    }
    
    /// Disables notifications for all events of a specific type and updates Core Data.
    ///
    /// This function:
    /// 1. Updates the UI state via `buttonClicked`
    /// 2. Collects identifiers for all matching event notifications
    /// 3. Removes matching events from `pendingNotifications`
    /// 4. Updates Core Data via `removeNotificationForSingleEvent`
    /// 5. Cancels all pending notifications for these events
    ///
    /// - Parameters:
    ///   - events: Array of `Event` objects to process
    ///   - eventType: The type of events to disable notifications for (e.g., "meeting")
    ///   - fetchedEvents: Fetched results container for CalendarEvent entities
    ///   - viewContext: Managed object context for Core Data operations
    ///
    /// ## Important
    /// - Requires UserNotifications permission
    /// - Must be called on the main queue (affects Core Data and UI)
    /// - Cleans up both in-memory pendingNotifications and actual scheduled notifications
    ///
    /// ## Example
    /// ```swift
    /// turnOffEventNotification(
    ///     events: upcomingEvents,
    ///     eventType: "reminder",
    ///     fetchedEvents: fetchedResults,
    ///     viewContext: container.viewContext
    /// )
    /// ```
    func turnOffEventNotification(events:[Event], eventType: String, fetchedEvents:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext) {
        buttonClicked(eventType: eventType, setTo: false)
        var ids:[String] = []
        for event in events {
            if event.eventType == eventType {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYYMMDDHHmm"
                let identifier = event.identifier + ":::" + event.eventType + ":::" + dateFormatter.string(from: event.start.dateTime)
                ids.append(identifier)
                updatePendingNotifications()
                pendingNotifications.removeAll(where: { e in
                    e.identifier == event.identifier
                })
                removeNotificationForSingleEvent(event: event, fetchedEvents: fetchedEvents, viewContext: viewContext)
            }
        }
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    /// Schedules a local notification for a specific event at the given date.
    ///
    /// Creates and schedules a notification with details about the upcoming event.
    /// The notification will fire at the specified `date`, showing the event's summary
    /// and time information.
    ///
    /// - Parameters:
    ///   - event: The `Event` object containing event details (summary, start/end times, etc.)
    ///   - date: The `Date` when the notification should trigger
    ///
    /// ## Important
    /// - Requires `UserNotifications` framework permission.
    /// - The notification identifier is generated from the event's details to ensure uniqueness.
    /// - Any existing notification with the same identifier will be removed first.
    ///
    /// ## Example
    /// ```swift
    /// let event = Event(
    ///     identifier: "meeting-123",
    ///     summary: "Team Standup",
    ///     start: ...,
    ///     end: ...,
    ///     eventType: "meeting"
    /// )
    /// // Schedule notification 15 minutes before event
    /// dispatchNotification(
    ///     event: event,
    ///     date: Calendar.current.date(byAdding: .minute, value: -15, to: event.start.dateTime)!
    /// )
    /// ```
    ///
    /// ## Notes
    /// - Notification content varies based on event duration:
    ///   - For multi-hour events: "EventName is starting in 15 minutes!"
    ///   - For single-time events: "Don't forget, EventName is happening tomorrow!"
    func dispatchNotification(event: Event, date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMDDHHmm"
        let identifier = event.identifier + ":::" + event.eventType + ":::" + dateFormatter.string(from: event.start.dateTime)
        
        let title = "Upcoming Event"
        
        let dateHelper = DateHelper()
        let startTimeString = dateHelper.getTime(for: event.start.dateTime)
        let endTimeString = dateHelper.getTime(for: event.end.dateTime)
        let body = startTimeString != endTimeString ? "\(event.summary) is starting in 15 minutes!" : "Don't forget, \(event.summary) is happening tomorrow!" // Some message that gives information about time and location
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default // Kinda cool if we could make our own notification sound 👀
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date), repeats: false)
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) //<= Set the trigger to this if you want to see what the notification looks like
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        
        notificationCenter.add(request)
    }
    
    /// Removes all pending notifications for events in the `pendingNotifications` collection.
    ///
    /// Iterates through all events in `pendingNotifications` and removes their associated notifications.
    /// Also handles Core Data context updates for each event.
    ///
    /// - Parameters:
    ///   - fetchedEvents: The fetched results container for calendar events (used for validation).
    ///   - viewContext: The managed object context for making Core Data updates.
    ///
    /// ## Important
    /// - Requires `UserNotifications` framework permission.
    /// - This will cancel all pending notifications for events in `pendingNotifications`.
    /// - Makes changes to the Core Data context (ensure it's called on the correct queue).
    ///
    /// ## Example
    /// ```swift
    /// // Clear all pending notifications for current events:
    /// clearPendingNotifications(
    ///     fetchedEvents: fetchedEvents,
    ///     viewContext: container.viewContext
    /// )
    /// ```
    func clearPendingNotifications(fetchedEvents: FetchedResults<CalendarEvent>, viewContext: NSManagedObjectContext)
    {
        for event in pendingNotifications
        {
            self.removeNotificationForSingleEvent(event: event, fetchedEvents: fetchedEvents, viewContext: viewContext)
        }
    }
    
    /// Removes all delivered notifications from Notification Center.
    ///
    /// This function clears all notifications that have already been delivered to the user
    /// and are still visible in the Notification Center. This does not affect pending scheduled notifications.
    ///
    /// ## Important
    /// - Requires `UserNotifications` framework permission.
    /// - Only affects notifications that have already been delivered (not pending ones).
    /// - User may still see notifications briefly before they're removed.
    ///
    /// ## Example
    /// ```swift
    /// // Clear all delivered notifications:
    /// cleanUpDeliveredNotifications()
    /// ```
    func cleanUpDeliveredNotifications()
    {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    /// Logs all pending notification requests to the console.
    ///
    /// This function fetches the current list of scheduled local notifications
    /// and prints their count and details (for debugging purposes).
    ///
    /// ## Example
    /// ```swift
    /// verifyNotifications()
    /// // Console output:
    /// // "3 Notifications scheduled"
    /// // [<UNNotificationRequest: 0x...>, ...]
    /// ```
    ///
    /// ## Important
    /// - Requires `UserNotifications` framework permission.
    /// - Debug-only: Avoid calling this in production code.
    func verifyNotifications()
    {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests { notifications in
            print(String(notifications.count) + " Notifications scheduled")
            print(notifications)
        }
    }
    
    /// Removes all pending notifications whose start time has passed.
    ///
    /// This function filters out entries in `pendingNotifications` where the `start.dateTime`
    /// is earlier than the current date. Useful for cleaning up expired notifications before processing.
    ///
    /// ## Example
    /// ```swift
    /// // Assuming `pendingNotifications` contains both future and past dates:
    /// updatePendingNotifications()
    /// // Only notifications with `start.dateTime >= Date()` remain.
    /// ```
    private func updatePendingNotifications()
    {
        pendingNotifications.removeAll { e in
            e.start.dateTime < Date()
        }
    }
}
