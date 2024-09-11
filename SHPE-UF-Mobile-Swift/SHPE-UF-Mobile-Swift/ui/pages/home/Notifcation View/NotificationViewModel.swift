//
//  NotificationViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Matthew Segura on 2/17/24.
//

import SwiftUI
import UserNotifications
import CoreData

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
    
    func notifyForSingleEvent(event:Event, fetchedEvents:FetchedResults<CalendarEvent>, viewContext:NSManagedObjectContext)
    {
        var notificationDate = event.start.dateTime
        if event.start.dateTime != event.end.dateTime {
            // Notify 30 minutes before the event start time
            notificationDate = Calendar.current.date(byAdding: .minute, value: -30, to: event.start.dateTime)!
        } else {
            // If the event is all-day, notify 12 hours before the start time
            notificationDate = Calendar.current.date(byAdding: .hour, value: -12, to: event.start.dateTime)!
        }
        updatePendingNotifications()
        pendingNotifications.append(event)
        dispatchNotification(event: event, date: notificationDate)
        CoreFunctions().updateCalendarEvent(events: fetchedEvents, viewContext: viewContext)
        CoreFunctions().saveCalendarEvent(events: fetchedEvents, viewContext: viewContext, calendarEvents: [event])
    }
    
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
    
    func clearPendingNotifications(fetchedEvents: FetchedResults<CalendarEvent>, viewContext: NSManagedObjectContext)
    {
        for event in pendingNotifications
        {
            self.removeNotificationForSingleEvent(event: event, fetchedEvents: fetchedEvents, viewContext: viewContext)
        }
    }
    
    private func updatePendingNotifications()
    {
        pendingNotifications.removeAll { e in
            e.start.dateTime < Date()
        }
    }
}


